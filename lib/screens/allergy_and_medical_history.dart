import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

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
        padding: EdgeInsets.symmetric(horizontal: context.w(24), vertical: context.h(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(10)),
            Text(
              "Share any past or current medical conditions",
              style: CustomFonts.textGrey14w400,
            ),
            SizedBox(height: context.h(24)),

            // Form Group Card
            Container(
              padding: EdgeInsets.all(context.w(20)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(context.r(24)),
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
                  SizedBox(height: context.h(4)),
                  Text(
                    "Please choose your allergy from the list below.",
                    style: CustomFonts.grey12w400,
                  ),
                  SizedBox(height: context.h(12)),
                  _buildDropdownSection(
                    value: selectedAllergy,
                    items: allergyItems,
                    onChanged: (val) {
                      setState(() {
                        selectedAllergy = val;
                      });
                    },
                  ),
                  SizedBox(height: context.h(24)),

                  // Medical Conditions Section
                  Text("Medical Conditions", style: CustomFonts.black18w600),
                  SizedBox(height: context.h(4)),
                  Text(
                    "Share any past or current medical conditions",
                    style: CustomFonts.grey12w400,
                  ),
                  SizedBox(height: context.h(12)),
                  _buildDropdownSection(
                    value: selectedMedicalConditions,
                    items: medicalConditions,
                    onChanged: (val) {
                      setState(() {
                        selectedMedicalConditions = val;
                      });
                    },
                  ),
                  SizedBox(height: context.h(24)),

                  // Current Medications Section
                  Text("Current Medications", style: CustomFonts.black18w600),
                  SizedBox(height: context.h(4)),
                  Text(
                    "List your current prescriptions or treatments",
                    style: CustomFonts.grey12w400,
                  ),
                  SizedBox(height: context.h(12)),
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
            SizedBox(height: context.h(32)),

            // Reusable Custom Button
            CustomButton(
              text: "Save & Update",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(40)),
          ],
        ),
      ),
    );
  }

  // Unified reusable Dropdown component
  // Unified reusable Dropdown component
  Widget _buildDropdownSection({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final valueListenable = ValueNotifier<String?>(value);

    return SizedBox(
      height: context.h(52),
      child: DropdownButtonFormField2<String>(
        valueListenable: valueListenable,
        style: CustomFonts.black13w600,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(12)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.r(14)),
            borderSide: const BorderSide(color: CustomColors.greyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.r(14)),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.r(14)),
            borderSide: const BorderSide(color: CustomColors.purpleColor),
          ),
        ),
        items: items.map((String item) {
          return DropdownItem<String>(
            value: item,
            height: context.h(48), // Item height set per-item in v3.x
            child: Text(item, style: CustomFonts.black13w600),
          );
        }).toList(),
        onChanged: (val) {
          valueListenable.value = val;
          onChanged(val);
        },
        buttonStyleData: const FormFieldButtonStyleData(
          padding: EdgeInsets.zero,
        ),
        menuItemStyleData: const MenuItemStyleData(
          useDecorationHorizontalPadding: true,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.r(14)),
            color: Colors.white,
          ),
          maxHeight: context.h(280),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade600,
            size: context.sp(20),
          ),
        ),
      ),
    );
  }
}