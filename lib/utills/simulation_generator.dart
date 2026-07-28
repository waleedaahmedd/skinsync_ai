import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/checkout_view_model.dart';

class SimulationGenerator {
  // Use Gemini 1.5 Flash for fast multi-modal processing
  static final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
  );

  /// Generates simulations for all non-null poses provided.
  /// Returns a map with keys 'front', 'left', 'right' containing the image bytes.
  Future<Map<String, Uint8List?>> generateAllSimulations({
    required XFile? front,
    required XFile? left,
    required XFile? right,
    required Ref ref,
  }) async {
    final results = <String, Uint8List?>{
      'front': null,
      'left': null,
      'right': null,
    };

    final checkoutState = ref.read(checkoutViewModel);
    final selectedTreatmentsAndAreas = checkoutState.selectedTreatmentsAndAreas;

    // 1. Construct the dynamic prompt base
    String treatmentDetails = "";
    for (var item in selectedTreatmentsAndAreas) {
      final areaDetails = item.selectedAreas.map((a) {
        String detail = a.target.name ?? "";
        if (a.material != null && a.material!.selectedQuantity > 0) {
          detail += " (Material: ${a.material!.name}, Quantity: ${a.material!.selectedQuantity})";
        }
        return detail;
      }).join(", ");
      treatmentDetails += "- ${item.treatment.name} on areas: $areaDetails\n";
    }

    final promptBase = """
Analyze this facial image and generate a high-quality aesthetic simulation showing the results of the following treatments:
$treatmentDetails

IMPORTANT: 
- Your response must consist ONLY of the raw Base64 string of the resulting image.
- Do not include any text, markdown formatting, or explanations. 
- Ensure the output is a valid JPEG/PNG image encoded in Base64.
""";

    // 2. Process all poses in parallel
    try {
      final List<Future<void>> tasks = [];

      if (front != null) {
        tasks.add(_processPose(front, promptBase).then((val) => results['front'] = val));
      }
      if (left != null) {
        tasks.add(_processPose(left, promptBase).then((val) => results['left'] = val));
      }
      if (right != null) {
        tasks.add(_processPose(right, promptBase).then((val) => results['right'] = val));
      }

      await Future.wait(tasks);
    } catch (e) {
      if (kDebugMode) {
        print("Error in multi-pose simulation generation: $e");
      }
    }

    return results;
  }

  Future<Uint8List?> _processPose(XFile image, String prompt) async {
    try {
      final bytes = await image.readAsBytes();

      final content = [
        Content.multi([
          TextPart(prompt),
          InlineDataPart('image/jpeg', bytes),
        ]),
      ];

      final response = await _model.generateContent(content);
      final responseText = response.text;

      if (responseText != null && responseText.trim().isNotEmpty) {
        // Clean and decode Base64
        final cleanedBase64 = responseText.replaceAll(RegExp(r'\s+'), '').replaceAll('`', '');
        return base64Decode(cleanedBase64);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error processing pose: $e");
      }
    }
    return null;
  }
}
