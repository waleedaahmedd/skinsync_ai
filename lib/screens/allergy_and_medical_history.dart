import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

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
      appBar: CustomAppBar(
        title:   Text(
             "Allergy & Medical History",
              style: CustomFonts.black26w600,
            )
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Share any past or current medical conditions",
                style: CustomFonts.black16w400,
              ),
              SizedBox(height: 25.h),
              Text("Allergy", style: CustomFonts.black18w500),
              SizedBox(height: 10.h),
              Text(
                "Please choose your allergy from the list below.",
                style: CustomFonts.grey16w400,
              ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 55.h,
                child: DropdownButtonFormField2<String>(
                  value: selectedAllergy,
                  style: CustomFonts.black16w400,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 15.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xff848484)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xff848484)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xff848484)),
                    ),
                  ),
                  hint: Text(
                    'Select your allergy',
                    style: CustomFonts.black16w400,
                  ),
                  items: allergyItems.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: CustomFonts.black18w400),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedAllergy = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 55.h,
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
                    maxHeight: 300.h,
                  ),
                  iconStyleData: IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xff494949),
                    ),
                    iconSize: 24.sp,
                  ),
                ),
              ),
              SizedBox(height: 23.h),
              Text("Medical Conditions", style: CustomFonts.black18w500),
              SizedBox(height: 10.h),
              Text(
                "Share any past or current medical conditions",
                style: CustomFonts.grey16w400,
              ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 55.h,
                child: DropdownButtonFormField2<String>(
                  value: selectedMedicalConditions,
                  style: CustomFonts.black16w400,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 15.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xff848484)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xff848484)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xff848484)),
                    ),
                  ),
        
                  items: medicalConditions.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: CustomFonts.black18w400),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedMedicalConditions = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 55.h,
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
                    maxHeight: 300.h,
                  ),
                  iconStyleData: IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xff494949),
                    ),
                    iconSize: 24.sp,
                  ),
                ),
              ),
              SizedBox(height: 23.h),
              Text("Current Medications", style: CustomFonts.black18w500),
              SizedBox(height: 10.h),
              Text(
                "List any medications you are currently taking",
                style: CustomFonts.grey16w400,
              ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 55.h,
                child: DropdownButtonFormField2<String>(
                  value: selectedCurrentMedications,
                  style: CustomFonts.black16w400,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 15.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xff848484)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xff848484)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xff848484)),
                    ),
                  ),
                  hint: Text(
                    'Select your allergy',
                    style: CustomFonts.black16w400,
                  ),
                  items: currentMedications.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: CustomFonts.black18w400),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedCurrentMedications = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 55.h,
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
                    maxHeight: 300.h,
                  ),
                  iconStyleData: IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xff494949),
                    ),
                    iconSize: 24.sp,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Save")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
