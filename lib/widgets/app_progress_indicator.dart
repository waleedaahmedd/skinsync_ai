import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'app_loader.dart';

class AppProgressIndicator extends StatelessWidget {
  final int current;
  final int total;
  final String? message;

  const AppProgressIndicator({
    super.key,
    required this.current,
    required this.total,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final double value = total > 0 ? current / total : 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppLoader(value: value),
        SizedBox(height: context.w(15)),
        Text(
          message != null
              ? '$message ($current/$total)'
              : 'Progress: $current/$total',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.w(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
