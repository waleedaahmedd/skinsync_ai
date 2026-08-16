import 'package:camera/camera.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../services/media_service.dart';

class SimulationImages {
  final XFile? frontBefore;
  final XFile? frontAfter;
  final XFile? rightBefore;
  final XFile? rightAfter;
  final XFile? leftBefore;
  final XFile? leftAfter;

  SimulationImages({
    this.frontBefore,
    this.frontAfter,
    this.rightBefore,
    this.rightAfter,
    this.leftBefore,
    this.leftAfter,
  });
}

class SimulationUrls {
  final String? frontBefore;
  final String? frontAfter;
  final String? rightBefore;
  final String? rightAfter;
  final String? leftBefore;
  final String? leftAfter;

  SimulationUrls({
    this.frontBefore,
    this.frontAfter,
    this.rightBefore,
    this.rightAfter,
    this.leftBefore,
    this.leftAfter,
  });
}

Future<SimulationUrls> uploadSimulationImages({
  required int userId,
  required SimulationImages images,
}) async {
  final mediaService = MediaService();

  Future<String?> upload(XFile? file, String path) async {
    if (file == null) return null;
    final url = await mediaService.uploadImage(path, file);
    if (url == null) {
      EasyLoading.showError('Failed to upload image');
    }
    return url;
  }

  // Uploading all images
  final results = await Future.wait([
    upload(images.frontAfter != null ? images.frontBefore : null,
        '$userId/treatment_option/front/before/'),
    upload(images.frontAfter, '$userId/treatment_option/front/after/'),
    upload(images.rightAfter != null ? images.rightBefore : null,
        '$userId/treatment_option/before/right/'),
    upload(images.rightAfter, '$userId/treatment_option/after/right/'),
    upload(images.leftAfter != null ? images.leftBefore : null,
        '$userId/treatment_option/before/left/'),
    upload(images.leftAfter, '$userId/treatment_option/after/left/'),
  ]);

  return SimulationUrls(
    frontBefore: results[0],
    frontAfter: results[1],
    rightBefore: results[2],
    rightAfter: results[3],
    leftBefore: results[4],
    leftAfter: results[5],
  );
}
