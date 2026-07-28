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
    model: 'gemini-2.5-flash-image',
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

    log("Treatment Details:\n$treatmentDetails");

    // Role-based clinical prompt for MedSpa simulations
    String getPrompt(String pose) => """
You are a professional aesthetic medical image simulation and image editing model specialized in realistic MedSpa before-and-after visualization.

Your task is to edit ONLY the provided facial image and create a realistic post-treatment simulation based on the selected treatments, treatment areas, materials, and quantities provided below.

IMPORTANT:
This is an IMAGE EDITING task only.
Do NOT analyze the face.
Do NOT diagnose conditions.
Do NOT recommend treatments.
Do NOT provide medical advice.
Do NOT change anything except the requested treatment areas.

==================================================
INPUT IMAGE
==================================================

Original Image:
$pose

==================================================
SELECTED TREATMENTS
==================================================

$treatmentDetails

Example:
- Treatment: Neurotoxin (Botox)
- Area: Jawline Tightening
- Quantity: 40 Units

- Treatment: Dermal Filler
- Area: Lips
- Quantity: 1 Syringe

==================================================
CLINICAL SIMULATION RULES
==================================================

Apply only the requested treatment effects.

The quantity/material provided controls the intensity of the visual effect.

Higher quantity:
- Creates a stronger but still realistic effect.

Lower quantity:
- Creates a subtle natural effect.

Never create exaggerated, artificial, or unrealistic changes.

==================================================
BOTULINUM TOXIN (BOTOX / NEUROTOXIN) AREA EFFECTS
==================================================

Forehead:
Soften forehead dynamic lines naturally.
Maintain forehead texture, pores, and natural expression.

Glabella Lines:
Reduce frown lines between eyebrows naturally.
Preserve eyebrow position and facial expression.

Eyebrow Lift:
Create a subtle eyebrow elevation effect only.
Do not change eyebrow thickness, shape, or hair.

Crow's Feet:
Reduce fine lines around outer eye corners.
Preserve eye shape and natural skin texture.

Bunny Lines:
Soften nasal bridge wrinkles naturally.
Maintain nose anatomy.

Under Eye Jelly Roll:
Reduce lower eyelid muscle prominence naturally.
Preserve eye structure and texture.

Nasal Tip Lift:
Create a subtle nasal tip elevation effect.
Do not reshape the nose.

Nose Flare Reduction:
Reduce nasal flare appearance subtly.
Maintain natural nostril anatomy.

Gummy Smile:
Create a subtle reduction effect while preserving natural lips and teeth.

Lip Flip:
Slightly enhance upper lip eversion only.
Do not increase lip volume.

Perioral Lines:
Soften lines around mouth naturally.

Downturned Mouth Corners:
Create a subtle upward mouth corner appearance.
Maintain natural expression.

Chin Dimpling:
Smooth chin dimpling naturally.
Preserve chin shape.

Masseter Reduction:
Create subtle lower-face slimming.
Reduce jaw width naturally while preserving identity.

Jawline Tightening:
Apply subtle jawline tightening.
Improve contour definition without changing face identity.

Platysmal Band:
Reduce neck band prominence naturally.
Preserve neck anatomy.

Jawline Lift:
Create subtle lower-face lifting effect.
Maintain natural jaw contour.

==================================================
DERMAL FILLER AREA EFFECTS
==================================================

Temples:
Restore temple volume naturally.
Quantity controls the amount of volume restoration.

Tear Trough:
Reduce under-eye hollowness and shadow.
Maintain natural eye anatomy.

Cheeks:
Restore mid-face volume naturally.
Create realistic cheek support.

Nasolabial Fold:
Soften folds naturally.
Do not erase natural facial structure.

Preauricular Area:
Add subtle volume support near ear area.

Lips:
Increase lip volume naturally.
Preserve lip border and avoid overfilling.

Marionette Lines:
Reduce lower mouth folds naturally.

Chin:
Increase chin projection subtly.
Maintain facial harmony.

Chin Shadow Area:
Improve chin contour balance naturally.

Jawline:
Enhance jawline definition.
Create natural contour refinement.

Pre-Jowl:
Improve lower face transition naturally.

==================================================
MATERIAL AND QUANTITY RULES
==================================================

Neurotoxin / Botox:
- Quantity represents treatment strength.
- Higher units produce stronger muscle relaxation.
- Never create frozen expressions.

Dermal Filler:
- Quantity represents volume amount.
- More syringes create more volume restoration.
- Never create overfilled appearance.

Other Materials:
Apply only the expected visual effect of that material.

==================================================
IMAGE PRESERVATION REQUIREMENTS
==================================================

The generated image must remain identical to the original image except for requested treatment areas.

Preserve exactly:

- Original image width
- Original image height
- Pixel dimensions
- Resolution
- Aspect ratio
- Image quality
- Compression quality
- Camera angle
- Face position
- Head pose
- Lighting
- Shadows
- Highlights
- Exposure
- Contrast
- Saturation
- White balance
- Color balance
- Skin tone
- Skin color
- Skin pores
- Skin texture
- Hair
- Eyebrows
- Eyelashes
- Eyes
- Iris color
- Nose (unless treated)
- Lips (unless treated)
- Teeth
- Neck
- Background
- Clothing
- Accessories

DO NOT:

- Crop image
- Resize image
- Rotate image
- Change image style
- Apply filters
- Beautify face
- Whiten skin
- Smooth entire face
- Add makeup
- Change hairstyle
- Replace face
- Modify untreated areas

==================================================
FINAL QUALITY REQUIREMENTS
==================================================

The result should look like a professional aesthetic consultation before/after simulation.

Changes should be:
- Natural
- Subtle
- Clinically realistic
- Anatomically correct
- Seamlessly blended

Only the selected treatment areas should show visible differences.

==================================================
OUTPUT
==================================================

Return ONLY the edited image.

No explanation.
No text.
No markdown.
No analysis.
No captions.

Return the image as binary image data.""";

    log("Simulation Prompt:\n${getPrompt('front')}");

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
