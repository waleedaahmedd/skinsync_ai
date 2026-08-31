import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import 'app_loader.dart';

class MessageCycler extends StatefulWidget {
  const MessageCycler({super.key});

  @override
  State<MessageCycler> createState() => _MessageCyclerState();
}

class _MessageCyclerState extends State<MessageCycler> {
  static const _messages = [
    'Analyzing your features...',
    'Understanding your unique profile...',
    'Mapping facial contours...',
    'Creating your personalized simulation...',
    'Visualizing your potential results...',
    'Generating your after preview...',
    'Almost ready...',
  ];

  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (_index < _messages.length - 1) {
        setState(() {
          _index++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            width: 0.65.sw,
            padding: EdgeInsets.symmetric(
              horizontal: context.w(20),
              vertical: context.h(18),
            ),
            decoration: BoxDecoration(
              color: CustomColors.blackColor,
              borderRadius: BorderRadius.circular(context.r(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              spacing: 10.h,
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLoader(),
                SizedBox(width: context.w(12)),
                Flexible(
                  child: Text(
                    _messages[_index],
                    style: CustomFonts.white14w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
