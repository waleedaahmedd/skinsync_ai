import 'dart:io';

import 'package:image/image.dart' as img;

import 'package:camera/camera.dart';

Future<XFile> flipXFileHorizontally(XFile xFile) async {
  // Read image bytes
  final bytes = await xFile.readAsBytes();

  // Decode image
  final img.Image? original = img.decodeImage(bytes);
  if (original == null) {
    throw Exception('Unable to decode image');
  }

  // Flip horizontally
  final img.Image flipped = img.flipHorizontal(original);

  // Write back to same path (or create a new path if you prefer)
  final File file = File(xFile.path);
  await file.writeAsBytes(img.encodeJpg(flipped), flush: true);

  // Return as XFile
  return XFile(file.path);
}
