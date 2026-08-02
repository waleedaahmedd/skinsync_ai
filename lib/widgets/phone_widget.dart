import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class PhoneWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueSetter<String>? onChanged;
  final void Function(Country country)? onCountryChanged;
  final String? initialCountryCode;
  final bool showLabel;
  final bool filled;
  final bool removeValidation;

  const PhoneWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onCountryChanged,
    this.initialCountryCode,
    this.showLabel = true,
    this.filled = false,
    this.removeValidation = false,
  });

  @override
  State<PhoneWidget> createState() => _PhoneWidgetState();
}

class _PhoneWidgetState extends State<PhoneWidget> {
  final FocusNode _focusNode = FocusNode();
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = Country.parse(widget.initialCountryCode ?? 'US');
  }

  @override
  void didUpdateWidget(covariant PhoneWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCountryCode != null &&
        widget.initialCountryCode != oldWidget.initialCountryCode) {
      setState(() {
        _selectedCountry = Country.parse(widget.initialCountryCode!);
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.h(10),
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
            hintText: '012 345 6798',
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
                // countryCodeWidth: context.w(45),
                moveAlongWithKeyboard: true,
                countryListTheme: CountryListThemeData(
                  bottomSheetWidth: MediaQuery.sizeOf(context).width,
                  bottomSheetHeight: context.h(560),
                  textStyle: TextStyle(fontSize: context.sp(14), color: Colors.black),
                  searchTextStyle: TextStyle(fontSize: context.sp(14)),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.only(
                    top: context.h(15),
                    bottom: context.h(27),
                    left: context.w(20),
                    right: context.w(20),
                  ),
                ),
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  setState(() {
                    _selectedCountry = country;
                  });
                  if (widget.onCountryChanged != null) {
                    widget.onCountryChanged!(country);
                  }
                },
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: context.w(12), right: context.w(4)),
                  child: Center(
                    child: Text(
                      _selectedCountry.flagEmoji,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: context.sp(14)),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "+ ${_selectedCountry.phoneCode}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColors.blackColor,
                      fontSize: context.sp(14),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.h(14.3)),
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
