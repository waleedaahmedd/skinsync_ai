import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../models/chat_message_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';

class MediaChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const MediaChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Container(
      constraints: BoxConstraints(maxWidth: context.w(320)),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.text.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.only(
                left: context.w(4),
                right: context.w(4),
                bottom: context.h(8),
              ),
              child: Text(
                message.text,
                style: isMe
                    ? CustomFonts.white14w400
                    : CustomFonts.black14w400,
              ),
            ),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(context.r(12)),
            child: message.mediaUrl != null && message.mediaUrl!.isNotEmpty
                ? Image.network(
                    message.mediaUrl!,
                    width: double.infinity,
                    height: context.h(200),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholderImage(context),
                  )
                : _buildPlaceholderImage(context),
          ),
          if (message.mediaCaption != null &&
              message.mediaCaption!.isNotEmpty) ...[
            SizedBox(height: context.h(8)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(4)),
              child: Text(
                message.mediaCaption!,
                style: isMe
                    ? CustomFonts.white12w400
                    : CustomFonts.grey12w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.h(180),
      color: CustomColors.greyColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: context.sp(40),
            color: CustomColors.silverColor,
          ),
          SizedBox(height: context.h(8)),
          Text(
            'Media Preview',
            style: CustomFonts.grey12w400,
          ),
        ],
      ),
    );
  }
}
