import 'dart:convert';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'simulation_prompts.dart';
import '../view_models/checkout_view_model.dart';

class SimulationGenerator {
  // Use gemini-1.5-flash for stable image processing
  static final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.1-flash-image',
  );

  /// Generates simulations for all non-null poses provided.
  Future<({Map<String, Uint8List> images, List<String> errors})> generateAllSimulations({
    required XFile? front,
    required XFile? left,
    required XFile? right,
    required Ref ref,
  }) async {
    final images = <String, Uint8List>{};
    final errors = <String>[];

    final checkoutState = ref.read(checkoutViewModel);
    final selectedTreatmentsAndAreas = checkoutState.selectedTreatmentsAndAreas;

    String treatmentDetails = "";
    for (var item in selectedTreatmentsAndAreas) {
      final areaDetails = item.selectedAreas.map((a) {
        String detail = a.target.name ?? "";
        if (a.material != null && a.material!.selectedQuantity > 0) {
          detail += " (${a.material!.selectedQuantity} units of ${a.material!.name})";
        }
        return detail;
      }).join(", ");
      treatmentDetails += "- ${item.treatment.name} on: $areaDetails\n";
    }

    log("Treatment Details:\n$treatmentDetails");

    String getPrompt(String pose) => SimulationPrompts.clinicalPrompt(
          pose: pose,
          treatmentDetails: treatmentDetails,
        );

    log("Simulation Prompt:\n${getPrompt('front')}");

    try {
      final List<Future<void>> tasks = [];

      if (front != null) {
        tasks.add(() async {
          try {
            final val = await _processPose('front', front, getPrompt('front'));
            if (val != null) images['front'] = val;
          } catch (e) {
            errors.add('Front: ${e.toString().replaceFirst('Exception: ', '')}');
          }
        }());
      }

      if (left != null) {
        tasks.add(() async {
          try {
            final val = await _processPose('left', left, getPrompt('left'));
            if (val != null) images['left'] = val;
          } catch (e) {
            errors.add('Left: ${e.toString().replaceFirst('Exception: ', '')}');
          }
        }());
      }

      if (right != null) {
        tasks.add(() async {
          try {
            final val = await _processPose('right', right, getPrompt('right'));
            if (val != null) images['right'] = val;
          } catch (e) {
            errors.add('Right: ${e.toString().replaceFirst('Exception: ', '')}');
          }
        }());
      }

      await Future.wait(tasks);
    } catch (e) {
      log("Error in multi-pose generation: $e");
      errors.add("Generation failed: $e");
    }

    return (images: images, errors: errors);
  }

  Future<Uint8List?> _processPose(String poseName, XFile image, String prompt) async {
    final bytes = await image.readAsBytes();
    log("Processing pose: $poseName (${bytes.length} bytes)");

    final content = [
      Content.multi([
        TextPart(prompt),
        InlineDataPart('image/jpeg', bytes),
      ]),
    ];

    final response = await _model.generateContent(content);
    
    // 1. Check for binary data output (Direct Image Response)
    for (var part in response.candidates.first.content.parts) {
      if (part is InlineDataPart) {
        log("AI returned direct binary data for $poseName (${part.bytes.length} bytes)");
        return part.bytes;
      }
    }

    // 2. Fallback to text parsing (Base64)
    String? responseText = response.text;
    log("AI RAW RESPONSE ($poseName): ${responseText?.substring(0, responseText.length > 50 ? 50 : responseText.length)}...");

    if (responseText != null && responseText.trim().isNotEmpty) {
      String cleanedBase64 = responseText.trim();
      
      if (cleanedBase64.contains('```')) {
        final regExp = RegExp(r'```(?:[a-zA-Z0-9]+)?\s*([\s\S]*?)\s*```');
        final match = regExp.firstMatch(cleanedBase64);
        if (match != null) {
          cleanedBase64 = match.group(1) ?? cleanedBase64;
        }
      }
      
      cleanedBase64 = cleanedBase64.replaceAll(RegExp(r'\s+'), '').replaceAll('`', '');
      
      if (cleanedBase64.contains(',')) {
        cleanedBase64 = cleanedBase64.split(',').last;
      }
      
      try {
        final decodedBytes = base64Decode(cleanedBase64);
        if (decodedBytes.isNotEmpty) {
          log("Successfully decoded Base64 for $poseName (${decodedBytes.length} bytes)");
          return decodedBytes;
        }
      } catch (e) {
        throw Exception("Failed to decode image data for $poseName.");
      }
    }
    
    throw Exception("AI failed to provide a valid image response for $poseName.");
  }
}
