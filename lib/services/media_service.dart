import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class MediaService {
  final _storage = FirebaseStorage.instance;
  static const int maxSizeBytes = 2 * 1024 * 1024;

  static MediaService? _instance;

  factory MediaService() {
    _instance ??= MediaService._();
    return _instance!;
  }

  MediaService._();

  Future<String?> uploadImage(String path, XFile image) async {
    final storagePath = '$path/${image.name}';
    final ref = _storage.ref().child(storagePath);
    final metadata = SettableMetadata(
      contentType: _imageContentType(image.name),
    );
    final bytes = await image.readAsBytes();
    final compressedBytes = await _compressImage(bytes);
    final task = ref.putData(compressedBytes, metadata);
    await task.whenComplete(() {});
    final url = await ref.getDownloadURL();
    log('Uploaded image path: $storagePath');
    log('Uploaded image URL: $url');
    return url;
  }

  String _imageContentType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return switch (ext) {
      // 'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      // 'gif' => 'image/gif',
      // 'webp' => 'image/webp',
      _ => throw Exception('Any format other than jpeg is not supported!'),
    };
  }

  Future<String?> uploadFile(String path, PlatformFile file) async {
    final storagePath = '$path/${file.name}';
    final ref = _storage.ref().child(storagePath);
    final metadata = SettableMetadata(
      contentType: file.extension == 'pdf'
          ? 'application/pdf'
          : 'application/octet-stream',
    );

    if (file.bytes != null) {
      final task = ref.putData(file.bytes!, metadata);
      await task.whenComplete(() {});
    } else if (file.path != null) {
      final task = ref.putFile(File(file.path!), metadata);
      await task.whenComplete(() {});
    } else {
      throw Exception('File data not available');
    }

    final url = await ref.getDownloadURL();
    log('Uploaded file path: $storagePath');
    log('Uploaded file URL: $url');
    return url;
  }

  Future<String?> uploadMedia({
    required String path,
    required dynamic file, // XFile | PlatformFile
  }) async {
    try {
      late String fileName;
      late Uint8List bytes;

      // XFile
      if (file is XFile) {
        fileName = file.name;
        bytes = await file.readAsBytes();
      }
      // PlatformFile
      else if (file is PlatformFile) {
        fileName = file.name;

        if (file.bytes == null) {
          throw Exception('PlatformFile.bytes is null. Use withData:true');
        }

        bytes = file.bytes!;
      } else {
        throw Exception('Unsupported file type');
      }

      final ext = fileName.split('.').last.toLowerCase();

      final storagePath = switch (ext) {
        'png' || 'gif' || 'webp' => throw Exception(
          'Any format other than jpeg is not supported!',
        ),
        'jpg' || 'jpeg' => '$path/image/$fileName',
        'mp4' || 'mov' || 'avi' || 'mkv' || 'webm' => '$path/video/$fileName',
        'pdf' => '$path/pdf/$fileName',
        _ => '$path/file/$fileName',
      };

      log('UPLOAD STARTED');
      log('PATH: $storagePath');

      final ref = _storage.ref().child(storagePath);
      if (storagePath.contains('/image/')) {
        bytes = await _compressImage(bytes);
      }
      final task = ref.putData(
        bytes,
        SettableMetadata(contentType: _contentType(ext)),
      );

      await task.whenComplete(() {});

      final url = await ref.getDownloadURL();

      log('UPLOAD SUCCESS');
      log('UPLOADED PATH: $storagePath');
      log('UPLOADED URL: $url');

      return url;
    } catch (e, s) {
      log('UPLOAD ERROR: $e', stackTrace: s);
      rethrow;
    }
  }

  String _contentType(String ext) {
    return switch (ext) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'gif' => 'image/gif',
      'webp' => 'image/webp',

      'mp4' => 'video/mp4',
      'mov' => 'video/quicktime',
      'avi' => 'video/x-msvideo',
      'mkv' => 'video/x-matroska',
      'webm' => 'video/webm',

      'pdf' => 'application/pdf',

      _ => 'application/octet-stream',
    };
  }

  Future<XFile?> downloadSimulationImage({
    int? simId,
    required bool isBefore,
    String? imageUrl,
  }) async {
    if (imageUrl == null) {
      return null;
    }
    final uri = Uri.parse(imageUrl);
    final ext = uri.path.split('.').last;
    final dir = await getApplicationCacheDirectory();
    final path =
        '${dir.path}/simulation_${isBefore ? 'before' : 'after'}_${simId ?? 0}.$ext';
    final file = File(path);
    if (await file.exists()) {
      return XFile(file.path);
    }
    final response = await get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    await file.writeAsBytes(response.bodyBytes);
    log('PATH: ${uri.path}');
    return XFile(path);
  }

  Future<Uint8List> _compressImage(Uint8List data) async {
    Uint8List result = Uint8List.fromList(data);
    int count = 0;
    while (result.length > maxSizeBytes) {
      result = await FlutterImageCompress.compressWithList(
        data,
        format: .jpeg,
        quality: 90,
      );
      count++;
      log('ITERATION # $count, SIZE: ${result.length}');
    }
    return result;
  }
}
