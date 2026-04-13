import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:skinsync_ai/utills/file_utils.dart';

class MediaService {
  final _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(String uniqueId, XFile image) async {
    final ref = _storage.ref().child(
      '$uniqueId/profile/${uniqueId.replaceAll('.', '')}${image.extension}',
    );
    final task = ref.putData(await image.readAsBytes());
    await task.whenComplete(() {});
    return await ref.getDownloadURL();
  }
}
