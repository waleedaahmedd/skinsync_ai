import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class MediaService {
  final _storage = FirebaseStorage.instance;

  static MediaService? _instance;

  MediaService._();

  factory MediaService() {
    _instance ??= MediaService._();
    return _instance!;
  }

  Future<String?> uploadImage(String path, XFile image) async {
    final ref = _storage.ref().child('$path/${image.name}');
    final task = ref.putData(await image.readAsBytes());
    await task.whenComplete(() {});
    return await ref.getDownloadURL();
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
}
