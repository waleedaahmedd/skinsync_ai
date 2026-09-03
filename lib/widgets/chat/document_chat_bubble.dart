import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../models/chat_message_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';

class DocumentChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const DocumentChatBubble({super.key, required this.message});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.text.isNotEmpty) ...[
            Text(
              message.text,
              style: isMe
                  ? CustomFonts.white14w400
                  : CustomFonts.black14w400,
            ),
            SizedBox(height: context.h(10)),
          ],
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(12),
              vertical: context.h(10),
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.white.withValues(alpha: 0.15)
                  : CustomColors.greyColor,
              borderRadius: BorderRadius.circular(context.r(10)),
              border: Border.all(
                color: isMe
                    ? Colors.white.withValues(alpha: 0.3)
                    : CustomColors.greyColor,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.picture_as_pdf_rounded,
                  size: context.sp(26),
                  color: isMe ? CustomColors.whiteColor : CustomColors.darkPurple,
                ),
                SizedBox(width: context.w(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.documentName ?? 'Document.pdf',
                        style: isMe
                            ? CustomFonts.white12w600
                            : CustomFonts.black12w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (message.documentSize != null)
                        Text(
                          message.documentSize!,
                          style: isMe
                              ? CustomFonts.white10w600
                              : CustomFonts.grey12w400,
                        ),
                    ],
                  ),
                ),
                SizedBox(width: context.w(8)),
                Icon(
                  Icons.download_rounded,
                  size: context.sp(20),
                  color: isMe ? CustomColors.whiteColor : CustomColors.darkPurple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
