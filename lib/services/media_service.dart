import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
}
