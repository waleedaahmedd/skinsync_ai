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
    _timer = Timer.periodic(const Duration(seconds: 3), (t) {
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
            width: 0.82.sw,
            padding: EdgeInsets.symmetric(
              horizontal: context.w(20),
              vertical: context.h(20),
            ),
            decoration: BoxDecoration(
              color: CustomColors.blackColor,
              borderRadius: BorderRadius.circular(context.r(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLoader(),
                SizedBox(height: context.h(16)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_messages.length, (index) {
                    return _buildMessageItem(context, _messages[index], index);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, String message, int index) {
    final bool isCompleted = index < _index;
    final bool isActive = index == _index;

    Widget leadingWidget;
    TextStyle textStyle;

    if (isCompleted) {
      leadingWidget = Icon(
        Icons.check_circle_rounded,
        color: const Color(0xFF4CAF50),
        size: context.sp(20),
      );
      textStyle = CustomFonts.white14w600.copyWith(
        color: Colors.white,
      );
    } else if (isActive) {
      leadingWidget = SizedBox(
        width: context.w(18),
        height: context.h(18),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
      textStyle = CustomFonts.white14w600.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );
    } else {
      leadingWidget = Container(
        width: context.w(18),
        height: context.h(18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade600,
            width: 1.5,
          ),
        ),
      );
      textStyle = CustomFonts.white14w600.copyWith(
        color: Colors.grey.shade500,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.h(6)),
      child: Row(
        children: [
          SizedBox(
            width: context.w(22),
            child: Center(child: leadingWidget),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Text(
              message,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
