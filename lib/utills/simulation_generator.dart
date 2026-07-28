import 'dart:convert';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/checkout_view_model.dart';

class SimulationGenerator {
  // Use gemini-1.5-flash for stable image processing
  static final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-1.5-flash',
  );

  /// Generates simulations for all non-null poses provided.
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

    // Role-based clinical prompt for MedSpa simulations
    String getPrompt(String pose) => """
You are a professional medical image editing and aesthetic visualization model.

Your task is to edit ONLY the provided facial image and create a realistic visual simulation of the requested aesthetic treatments.

Treat this as an image editing task only.
Do NOT analyze the patient's face, diagnose conditions, recommend treatments, estimate age, assess attractiveness, or make any medical judgments.

Requested Treatments:
$treatmentDetails

Pose:
$pose

Editing Rules:
1. Apply ONLY the treatments and quantities explicitly provided above.
2. Apply changes ONLY to the specified treatment areas.
3. Do NOT modify any untreated area of the face.
4. Preserve the person's identity exactly.
5. Preserve facial proportions, facial expression, eye shape, nose, lips (unless explicitly treated), ears, hair, eyebrows, eyelashes, teeth, clothing, jewelry, and accessories.
6. Preserve the original image composition, camera angle, head pose, lighting, shadows, skin tone, color balance, exposure, white balance, background, and image style.
7. Do NOT change the image resolution, crop, zoom, rotate, or replace the face.
8. Do NOT add makeup, beautification filters, skin whitening, smoothing filters, glamour effects, or artistic styling unless explicitly requested.
9. Simulate only realistic clinical results that would reasonably be expected after the specified treatments.
10. Respect the specified product quantities and treatment locations. Greater quantities may produce proportionally stronger—but still medically realistic—visual changes.
11. Blend all edits seamlessly with the surrounding skin so there are no visible editing artifacts.
12. Maintain natural skin texture and pores. Avoid an artificial or over-smoothed appearance.
13. Produce a professional "after treatment" simulation suitable for patient consultation.
14. If multiple treatments affect the same area, combine them naturally into a single realistic result.
15. Do not introduce any modifications beyond those explicitly requested.

Output Requirements:
- Return only the edited image.
- Do not return explanations, analysis, medical advice, captions, or markdown.
- Return the edited image as binary image data.
""";


    try {
      final List<Future<void>> tasks = [];

      if (front != null) {
        tasks.add(_processPose('front', front, getPrompt('front')).then((val) => results['front'] = val));
      }
      if (left != null) {
        tasks.add(_processPose('left', left, getPrompt('left')).then((val) => results['left'] = val));
      }
      if (right != null) {
        tasks.add(_processPose('right', right, getPrompt('right')).then((val) => results['right'] = val));
      }

      await Future.wait(tasks);
    } catch (e) {
      log("Error in multi-pose generation: $e");
    }

    return results;
  }

  Future<Uint8List?> _processPose(String poseName, XFile image, String prompt) async {
    try {
      final bytes = await image.readAsBytes();
      log("Processing pose: $poseName (${bytes.length} bytes)");
      log("FULL PROMPT ($poseName):\n$prompt");

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
          log("Base64 decoding failed for $poseName");
        }
      } else {
        log("AI returned empty text response for $poseName");
      }
    } catch (e) {
      log("Error processing pose $poseName: $e");
    }
    return null;
  }
}
