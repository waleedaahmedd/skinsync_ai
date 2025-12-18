import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/screens/get_started_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

import 'get_notified_screen.dart';

class YourProfileScreen extends StatelessWidget {
  const YourProfileScreen({super.key});
    static const String routeName = '/YourProfileScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.heightOf(context)),
        decoration: BoxDecoration(
          gradient: CustomColors.purpleWhiteBlueGradient,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 104.h),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipOval(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.asset(
                        DummyAssets.profile,
                        fit: BoxFit.cover,
                        height: 75.w,
                        width: 75.w,
                      ),
                    ),
                    Positioned(
                      bottom: -6, // or 0
                      right: -6,
                      child: Container(
                      
                        height: 35.w,
                        width: 35.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.black,
                              size: 21.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 27.h),
                Text("Your Profile", style: CustomFonts.black30w600),
                SizedBox(height: 4.h),
                Text(
                  "Introduce yourself to others in your events.",
                  style: CustomFonts.black18w400,
                ),
                SizedBox(height: 22.h),
                TextField(
                  style: CustomFonts.black18w400,
                  decoration: InputDecoration(hintText: "Your Name")),
                SizedBox(height: 20.h),
                TextField(
                  style: CustomFonts.black18w400,decoration: InputDecoration(hintText: "Phone Number")),
                SizedBox(height: 20.h),
                TextField(
                  style: CustomFonts.black18w400,decoration: InputDecoration(hintText: "Email Address")),
                SizedBox(height: 20.h),
                TextField(
                  style: CustomFonts.black18w400,decoration: InputDecoration(hintText: "Location")),
                SizedBox(height: 20.h),
                TextField(
                  style: CustomFonts.black18w400,
                  maxLines: 4,
                  decoration: InputDecoration(hintText: "Bio"),
                ),
                SizedBox(height: 35.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () {
                    Navigator.pushReplacementNamed(context,GetNotifiedScreen.routeName);
                  }, child: Text("Next")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
