import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cross_file/cross_file.dart';
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

  // Create a new file with a unique name
  final tempDir = await getTemporaryDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final newFilePath = '${tempDir.path}/flipped_$timestamp.jpg';
  final File newFile = File(newFilePath);
  await newFile.writeAsBytes(img.encodeJpg(flipped));

  // Return as XFile
  return XFile(newFile.path);
}

Future<XFile> cropImageToCircle(XFile xFile, {
  required double centerXPercent,
  required double centerYPercent,
  required double radiusPercent,
  bool flipHorizontally = false,
}) async {
  // 1. First, compress/resize the image natively to a manageable size (e.g., max 1080px)
  // This prevents OutOfMemory crashes on high-res Android cameras (Android 12+)
  final tempDir = await getTemporaryDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final compressedPath = '${tempDir.path}/temp_capture_$timestamp.jpg';

  final XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
    xFile.path,
    compressedPath,
    quality: 90,
    minWidth: 1080,
    minHeight: 1080,
  );

  final targetFile = compressedXFile ?? xFile;
  final bytes = await targetFile.readAsBytes();

  // Decode image
  img.Image? original = img.decodeImage(bytes);
  if (original == null) {
    throw Exception('Unable to decode image');
  }

  // Flip horizontally if needed (combine operations to avoid double processing)
  if (flipHorizontally) {
    original = img.flipHorizontal(original);
  }

  final imageWidth = original.width;
  final imageHeight = original.height;

  // Calculate circle center and radius in image coordinates
  final centerX = (imageWidth * centerXPercent).round();
  final centerY = (imageHeight * centerYPercent).round();
  final radius = (imageWidth * radiusPercent).round();

  // Calculate crop rectangle (square that fits the circle)
  final cropSize = radius * 2;
  final cropX = (centerX - radius).clamp(0, imageWidth - cropSize);
  final cropY = (centerY - radius).clamp(0, imageHeight - cropSize);
  final finalCropSize = cropSize.clamp(0, imageWidth - cropX).clamp(0, imageHeight - cropY);

  // Crop the image
  final img.Image cropped = img.copyCrop(
    original,
    x: cropX,
    y: cropY,
    width: finalCropSize,
    height: finalCropSize,
  );

  // Create a new file with a unique name
  final tempDir = await getTemporaryDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final newFilePath = '${tempDir.path}/cropped_$timestamp.jpg';
  final File newFile = File(newFilePath);
  await newFile.writeAsBytes(img.encodeJpg(cropped, quality: 95));

  // Return as XFile
  return XFile(newFile.path);
}

Future<XFile?> base64ToXFile(
  String base64Image, {
  String fileName = 'image.jpg',
}) async {
  // Remove data URI prefix if present
  final cleanedBase64 = base64Image.contains(',')
      ? base64Image.split(',').last
      : base64Image;

  final bytes = base64Decode(cleanedBase64);
  return bytesToXFile(bytes, fileName);
}

Future<XFile?> bytesToXFile(
  Uint8List bytes,
  String fileName,
) async {
  if (bytes.isEmpty) {
    return null;
  }
  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/$fileName';

  final file = File(filePath);
  await file.writeAsBytes(bytes);

  return XFile(file.path);
}
