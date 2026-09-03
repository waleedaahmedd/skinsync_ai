import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../screens/chat_list_screen.dart';
import '../utils/color_constant.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ChatListScreen.routeName);
      },
      child: Container(
        padding: EdgeInsets.all(context.r(14)),
        decoration: BoxDecoration(
          gradient: CustomColors.purpleBlueGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Icon(
          Icons.chat_bubble_rounded,
          color: CustomColors.blackColor,
          size: context.sp(22),
        ),
      ),
    );
  }
}
