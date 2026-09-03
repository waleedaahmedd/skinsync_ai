import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../screens/chat_list_screen.dart';
import '../utils/color_constant.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: CustomColors.darkPurple.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: CustomColors.darkPurple,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            Navigator.of(context).pushNamed(ChatListScreen.routeName);
          },
          child: Padding(
            padding: EdgeInsets.all(context.r(14)),
            child: Icon(
              Icons.chat_bubble_rounded,
              color: CustomColors.whiteColor,
              size: context.sp(22),
            ),
          ),
        ),
      ),
    );
  }
}
