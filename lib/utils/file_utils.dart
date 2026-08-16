import 'package:image_picker/image_picker.dart';

extension FileUtils on XFile {
  String get extension {
    final parts = path.split('.');
    if (parts.length < 2) {
      return '';
    }
    return '.${parts.last}';
  }
}
