import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../models/chat_message_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';

class NormalChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const NormalChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Container(
      constraints: BoxConstraints(maxWidth: context.w(320)),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(12),
      ),
      decoration: BoxDecoration(
        color: isMe ? CustomColors.darkPurple : CustomColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.r(16)),
          topRight: Radius.circular(context.r(16)),
          bottomLeft: Radius.circular(isMe ? context.r(16) : context.r(2)),
          bottomRight: Radius.circular(isMe ? context.r(2) : context.r(16)),
        ),
        border: Border.all(
          color: isMe ? CustomColors.darkPurple : CustomColors.greyColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        message.text,
        style: isMe
            ? CustomFonts.white14w400
            : CustomFonts.black14w400,
      ),
    );
  }
}
