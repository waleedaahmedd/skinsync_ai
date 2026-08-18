import 'package:camera/camera.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../services/media_service.dart';
import '../widgets/app_progress_indicator.dart';

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

  final uploadTasks = [
    {
      'file': images.frontAfter != null ? images.frontBefore : null,
      'path': '$userId/treatment_option/front/before/'
    },
    {
      'file': images.frontAfter,
      'path': '$userId/treatment_option/front/after/'
    },
    {
      'file': images.rightAfter != null ? images.rightBefore : null,
      'path': '$userId/treatment_option/before/right/'
    },
    {
      'file': images.rightAfter,
      'path': '$userId/treatment_option/after/right/'
    },
    {
      'file': images.leftAfter != null ? images.leftBefore : null,
      'path': '$userId/treatment_option/before/left/'
    },
    {'file': images.leftAfter, 'path': '$userId/treatment_option/after/left/'},
  ];

  final int totalToUpload = uploadTasks.where((e) => e['file'] != null).length;
  int currentCount = 0;

  void showProgress() {
    currentCount++;
    EasyLoading.show(
      indicator: AppProgressIndicator(
        current: currentCount,
        total: totalToUpload,
        message: 'Uploading Images...',
      ),
    );
  }

  if (totalToUpload > 0) {
    EasyLoading.show(
      indicator: AppProgressIndicator(
        current: 0,
        total: totalToUpload,
        message: 'Uploading Images...',
      ),
    );
  }

  Future<String?> upload(XFile? file, String path) async {
    if (file == null) return null;
    final url = await mediaService.uploadImage(path, file);
    if (url == null) {
      EasyLoading.showError('Failed to upload image');
    }
    showProgress();
    return url;
  }

  // Uploading all images in parallel while tracking progress
  final results = await Future.wait(
    uploadTasks.map((task) => upload(task['file'] as XFile?, task['path'] as String)),
  );

  return SimulationUrls(
    frontBefore: results[0],
    frontAfter: results[1],
    rightBefore: results[2],
    rightAfter: results[3],
    leftBefore: results[4],
    leftAfter: results[5],
  );
}
