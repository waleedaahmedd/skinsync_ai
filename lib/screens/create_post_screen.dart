import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../utills/custom_fonts.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showTitle: true,
        title: "Create Post",
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  hintStyle: CustomFonts.grey14w400,
                  border: InputBorder.none,
                ),
                style: CustomFonts.black14w400,
              ),
            ),
            // TODO: Add image picker UI here
            SizedBox(height: 20.h),
            CustomButton(
              text: "Post",
              onPressed: () {
                // TODO: Implement post creation logic
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
