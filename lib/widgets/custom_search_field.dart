import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class CustomSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  const CustomSearchField({
    super.key,
    this.controller,
    this.hintText = "Search...",
    this.onChanged,
    this.onClear,
    this.focusNode,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late final TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _showClearButton = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (_showClearButton != hasText) {
      setState(() {
        _showClearButton = hasText;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      style: CustomFonts.black18w400,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: _showClearButton
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _controller.clear();
                  if (widget.onChanged != null) {
                    widget.onChanged!("");
                  }
                  if (widget.onClear != null) {
                    widget.onClear!();
                  }
                },
              )
            : null,
        hintText: widget.hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: CustomColors.greyColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: CustomColors.purpleColor),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
