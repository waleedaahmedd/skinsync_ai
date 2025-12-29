import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:cross_file/cross_file.dart';

import 'package:camera/camera.dart';

// Future<XFile> flipXFileHorizontally(XFile xFile) async {
//   // Read image bytes
//   final bytes = await xFile.readAsBytes();

//   // Decode image
//   final img.Image? original = img.decodeImage(bytes);
//   if (original == null) {
//     throw Exception('Unable to decode image');
//   }

//   // Flip horizontally
//   final img.Image flipped = img.flipHorizontal(original);

//   // Write back to same path (or create a new path if you prefer)
//   final File file = File(xFile.path);
//   await file.writeAsBytes(img.encodeJpg(flipped), flush: true);

//   // Return as XFile
//   return XFile(file.path);
// }

Future<XFile> base64ToXFile(
  String base64Image, {
  String fileName = 'image.jpg',
}) async {
  // Remove data URI prefix if present
  final cleanedBase64 = base64Image.contains(',')
      ? base64Image.split(',').last
      : base64Image;

  final bytes = base64Decode(cleanedBase64);

  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/$fileName';

  final file = File(filePath);
  await file.writeAsBytes(bytes);

  return XFile(file.path);
}
