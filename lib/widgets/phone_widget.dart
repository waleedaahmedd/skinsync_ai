
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';


class PhoneWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueSetter<String>? onChanged;
  final bool showLabel;
  final bool filled;
  final bool removeValidation;

  const PhoneWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.showLabel = true,
    this.filled = false,
    this.removeValidation = false,
  });

  @override
  State<PhoneWidget> createState() => _PhoneWidgetState();
}

class _PhoneWidgetState extends State<PhoneWidget> {
  final FocusNode _focusNode = FocusNode();
  Country _selectedCountry = Country.parse('US');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.h,
      children: [
        TextFormField(
         validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 9) {
              return 'Phone number must be at least 9 digits';
            }
            return null; // Valid input
          },
          controller: widget.controller,
          // focusNode: _focusNode,
          onChanged: widget.onChanged,
          autofocus: false,
          inputFormatters: [
            LengthLimitingTextInputFormatter(11),
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: CustomFonts.black18w400,
          onTapOutside: (_) {
            _focusNode.unfocus();
          },
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            
            
            hintText: '921 - 2341 -99908',
            // hintStyle:
            //     Theme.of(context).inputDecorationTheme.hintStyle!.copyWith(
            //           // color: Colors.amber
            //           fontFamily: "General Sans",
            //         ),
            hintStyle: CustomFonts.grey18w400,
            prefixIcon: _buildPhoneNumberPicker(context: context),
          ),
        ),
      ],
    );
  }

  IntrinsicHeight _buildPhoneNumberPicker({required BuildContext context}) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              // Open country picker dialog
              showCountryPicker(
                // countryCodeWidth: 45.w,
                moveAlongWithKeyboard: true,
                countryListTheme: CountryListThemeData(
                  bottomSheetWidth: MediaQuery.sizeOf(context).width,
                  bottomSheetHeight: 560.h,
                  textStyle: TextStyle(fontSize: 14.sp,color: Colors.black),
                  searchTextStyle: TextStyle(fontSize: 14.sp),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.only(
                    top: 15.h,
                    bottom: 27.h,
                    left: 20.w,
                    right: 20.w,
                  ),
                ),
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  setState(() {
                    _selectedCountry = country;
                  });
                },
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.w, right: 4.w),
                  child: Center(
                    child: Text(
                      _selectedCountry.flagEmoji,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // fontFamily: languageController
                        // .fontFamily.value,
                        fontSize: 14.sp,
                      ), // Adjust flag size
                    ),
                  ),
                ),
                Center(
                  child: Text(
                   "+ ${_selectedCountry.phoneCode}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColors.blackColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.3.h),
            child: const VerticalDivider(
              color: Color(0xffE2E5E8),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
