import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showTitle;
  final EdgeInsetsGeometry? padding;

  const CustomAppBar({
    super.key,
    this.title = "",
    this.onBackTap,
    this.actions,
    this.showBackButton = true,
    this.showTitle = true,
    this.padding,
  });

  @override
  Size get preferredSize => Size.fromHeight(80.h);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(horizontal: context.w(30), vertical: context.h(10)),
        child: Row(
          children: [
            if (showBackButton) ...[
              GestureDetector(
                onTap: onBackTap ?? () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(context.w(8)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: context.sp(16),
                    color: CustomColors.blackColor,
                  ),
                ),
              ),
              SizedBox(width: context.w(15)),
            ],
            if (showTitle)
              Expanded(
                child: Text(
                  title,
                  style: CustomFonts.black24w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              const Spacer(),
            if (actions != null) ...[
              SizedBox(width: context.w(10)),
              ...actions!,
            ],
          ],
        ),
      ),
    );
  }
}
