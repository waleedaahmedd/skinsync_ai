import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/widgets/custom_button.dart';

class AllergyAndMedicalHistory extends StatefulWidget {
  const AllergyAndMedicalHistory({super.key});
  static const routeName = "/AllergyAndMedicalHistory";

  @override
  State<AllergyAndMedicalHistory> createState() =>
      _AllergyAndMedicalHistoryState();
}

class _AllergyAndMedicalHistoryState extends State<AllergyAndMedicalHistory> {
  String? selectedAllergy = 'Allergy Free';
  String? selectedMedicalConditions = 'Diabetes';
  String? selectedCurrentMedications = 'Metformin';

  final List<String> allergyItems = [
    'Allergy Free',
    'Peanuts',
    'Dairy',
    'Eggs',
    'Shellfish',
    'Wheat',
  ];
  final List<String> medicalConditions = [
    'Diabetes',
    'Asthma',
    'Heart Disease',
    'Epilepsy',
    'Arthritis',
    'Migraine',
    'Anemia',
  ];
  final List<String> currentMedications = [
    'Metformin',
    'Pain Relievers',
    'Antibiotics',
    'Antihistamines',
    'Inhalers',
    'Insulin',
    'Diabetes Medication',
    'Thyroid Medication',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showTitle: true, title: "Allergy & Medical History"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Share any past or current medical conditions",
              style: CustomFonts.textGrey14w400,
            ),
            SizedBox(height: 24.h),

            // Form Group Card
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: CustomColors.greyColor.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.015),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Allergy Section
                  Text("Allergy Profile", style: CustomFonts.black18w600),
                  SizedBox(height: 4.h),
                  Text(
                    "Please choose your allergy from the list below.",
                    style: CustomFonts.grey12w400,
                  ),
                  SizedBox(height: 12.h),
                  _buildDropdownSection(
                    value: selectedAllergy,
                    items: allergyItems,
                    onChanged: (val) {
                      setState(() {
                        selectedAllergy = val;
                      });
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Medical Conditions Section
                  Text("Medical Conditions", style: CustomFonts.black18w600),
                  SizedBox(height: 4.h),
                  Text(
                    "Share any past or current medical conditions",
                    style: CustomFonts.grey12w400,
                  ),
                  SizedBox(height: 12.h),
                  _buildDropdownSection(
                    value: selectedMedicalConditions,
                    items: medicalConditions,
                    onChanged: (val) {
                      setState(() {
                        selectedMedicalConditions = val;
                      });
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Current Medications Section
                  Text("Current Medications", style: CustomFonts.black18w600),
                  SizedBox(height: 4.h),
                  Text(
                    "List your current prescriptions or treatments",
                    style: CustomFonts.grey12w400,
                  ),
                  SizedBox(height: 12.h),
                  _buildDropdownSection(
                    value: selectedCurrentMedications,
                    items: currentMedications,
                    onChanged: (val) {
                      setState(() {
                        selectedCurrentMedications = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Reusable Custom Button
            CustomButton(
              text: "Save & Update",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  // Unified reusable Dropdown component
  Widget _buildDropdownSection({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      height: 52.h,
      child: DropdownButtonFormField2<String>(
        value: value,
        style: CustomFonts.black13w600,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: CustomColors.greyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: CustomColors.purpleColor),
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: CustomFonts.black13w600),
          );
        }).toList(),
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 52.h,
          width: double.infinity,
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: Colors.white,
          ),
          maxHeight: 280.h,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade600,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}