import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/string_utils.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../models/requests/medical_history_request.dart';
import '../view_models/medical_history_view_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class AllergyAndMedicalHistory extends ConsumerStatefulWidget {
  const AllergyAndMedicalHistory({super.key});
  static const routeName = "/AllergyAndMedicalHistory";

  @override
  ConsumerState<AllergyAndMedicalHistory> createState() =>
      _AllergyAndMedicalHistoryState();
}

class _AllergyAndMedicalHistoryState
    extends ConsumerState<AllergyAndMedicalHistory> {
  // Defaults set to empty (unselected)
  List<String> selectedAllergies = [];
  List<String> selectedMedicalConditions = [];
  List<String> selectedCurrentMedications = [];

  // Guards against re-populating from the provider after the user has
  // started editing (e.g. if fetchPatientMedicalHistory ever re-runs).
  bool _hasHydratedFromResponse = false;

  // Added 'None' to all option lists
  final List<String> allergyItems = [
    'None',
    'Peanuts',
    'Dairy',
    'Eggs',
    'Shellfish',
    'Wheat',
  ];
  final List<String> medicalConditions = [
    'None',
    'Diabetes',
    'Asthma',
    'Heart Disease',
    'Epilepsy',
    'Arthritis',
    'Migraine',
    'Anemia',
  ];
  final List<String> currentMedications = [
    'None',
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicalHistoryProvider.notifier).fetchPatientMedicalHistory();
    });

    super.initState();
  }

  // Sends an empty list instead of ['None'] (or any stale selection)
  // whenever 'None' is the active choice.
  List<String> _resolveForSubmit(List<String> selected) {
    if (selected.isEmpty || selected.contains('None')) return [];
    return selected;
  }

Future<void> _onSave() async {
  final request = MedicalHistoryRequest(
    allergies: _resolveForSubmit(selectedAllergies),
    medicalConditions: _resolveForSubmit(selectedMedicalConditions),
    currentMedications: _resolveForSubmit(selectedCurrentMedications),
  );
  final patientId =
      ref.read(medicalHistoryProvider).medicalHistory?.patientId;
  EasyLoading.show();
  final success = await ref
      .read(medicalHistoryProvider.notifier)
      .updateMedicalHistory(patientId, request);
  EasyLoading.dismiss();

  if (!mounted) return;

  if (!success) {
    final error = ref.read(medicalHistoryProvider).errorMessage;
    EasyLoading.showError(error ?? "Failed to update medical history");
    return;
  }
  EasyLoading.showSuccess("Medical history updated successfully");
}
 
  @override
  Widget build(BuildContext context) {
    // Populate the chips from the fetched record the first time data arrives.
    ref.listen(medicalHistoryProvider, (previous, next) {
      if (_hasHydratedFromResponse) return;
      final history = next.medicalHistory;
      if (history == null) return;

      setState(() {
        selectedAllergies = history.allergies ?? [];
        selectedMedicalConditions = history.medicalConditions ?? [];
        selectedCurrentMedications = history.currentMedications ?? [];
        _hasHydratedFromResponse = true;
      });
    });

    final isLoading = ref.watch(
      medicalHistoryProvider.select((state) => state.loading),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showTitle: true,
        title: "Allergy & Medical History",
      ),
      body: isLoading && !_hasHydratedFromResponse
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: context.w(24),
                vertical: context.h(10),
              ),
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
                          "Please choose your allergies from the list below.",
                          style: CustomFonts.grey12w400,
                        ),
                        SizedBox(height: context.h(12)),
                        _buildMultiSelectSection(
                          placeholder: "Select Allergies",
                          selectedItems: selectedAllergies,
                          allItems: allergyItems,
                          onSelectionChanged: (newList) {
                            setState(() {
                              selectedAllergies = newList;
                            });
                          },
                        ),
                        SizedBox(height: context.h(24)),

                        // Medical Conditions Section
                        Text(
                          "Medical Conditions",
                          style: CustomFonts.black18w600,
                        ),
                        SizedBox(height: context.h(4)),
                        Text(
                          "Share any past or current medical conditions",
                          style: CustomFonts.grey12w400,
                        ),
                        SizedBox(height: context.h(12)),
                        _buildMultiSelectSection(
                          placeholder: "Select Medical Conditions",
                          selectedItems: selectedMedicalConditions,
                          allItems: medicalConditions,
                          onSelectionChanged: (newList) {
                            setState(() {
                              selectedMedicalConditions = newList;
                            });
                          },
                        ),
                        SizedBox(height: context.h(24)),

                        // Current Medications Section
                        Text(
                          "Current Medications",
                          style: CustomFonts.black18w600,
                        ),
                        SizedBox(height: context.h(4)),
                        Text(
                          "List your current prescriptions or treatments",
                          style: CustomFonts.grey12w400,
                        ),
                        SizedBox(height: context.h(12)),
                        _buildMultiSelectSection(
                          placeholder: "Select Current Medications",
                          selectedItems: selectedCurrentMedications,
                          allItems: currentMedications,
                          onSelectionChanged: (newList) {
                            setState(() {
                              selectedCurrentMedications = newList;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.h(32)),

                  // Reusable Custom Button
                  CustomButton(text: "Save & Update", onPressed: _onSave),
                  SizedBox(height: context.h(40)),
                ],
              ),
            ),
    );
  }

  // Multi-Select Section (Field + Chips Below)
  Widget _buildMultiSelectSection({
    required String placeholder,
    required List<String> selectedItems,
    required List<String> allItems,
    required ValueChanged<List<String>> onSelectionChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input Selection Box
        InkWell(
          onTap: () => _showSelectionSheet(
            title: placeholder,
            selectedItems: selectedItems,
            allItems: allItems,
            onSelectionChanged: onSelectionChanged,
          ),
          borderRadius: BorderRadius.circular(context.r(14)),
          child: Container(
            height: context.h(52),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: context.w(12)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.r(14)),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedItems.isEmpty
                      ? placeholder
                      : "${selectedItems.length} Selected",
                  style: selectedItems.isEmpty
                      ? CustomFonts.grey12w400
                      : CustomFonts.black13w600,
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade600,
                  size: context.sp(20),
                ),
              ],
            ),
          ),
        ),

        // Display Chips Below Field
        if (selectedItems.isNotEmpty) ...[
          SizedBox(height: context.h(10)),
          Wrap(
            spacing: context.w(8),
            runSpacing: context.h(8),
            children: selectedItems.map((item) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(10),
                  vertical: context.h(6),
                ),
                decoration: BoxDecoration(
                  color: CustomColors.purpleColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(context.r(8)),
                  border: Border.all(
                    color: CustomColors.purpleColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item,
                      style: CustomFonts.black13w600.copyWith(
                        color: CustomColors.purpleColor,
                        fontSize: context.sp(12),
                      ),
                    ),
                    SizedBox(width: context.w(6)),
                    GestureDetector(
                      onTap: () {
                        final updatedList = List<String>.from(selectedItems)
                          ..remove(item);
                        onSelectionChanged(updatedList);
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: context.sp(14),
                        color: CustomColors.purpleColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  // Reusable Bottom Sheet for Multi-Selection
  void _showSelectionSheet({
    required String title,
    required List<String> selectedItems,
    required List<String> allItems,
    required ValueChanged<List<String>> onSelectionChanged,
  }) {
    List<String> tempSelected = List.from(selectedItems);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.r(24)),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.sizeOf(context).height * 0.6,
              padding: EdgeInsets.all(context.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title.capitalize, style: CustomFonts.black18w600),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allItems.length,
                      itemBuilder: (context, index) {
                        final item = allItems[index];
                        final isSelected = tempSelected.contains(item);

                        return CheckboxListTile(
                          activeColor: CustomColors.purpleColor,
                          title: Text(item, style: CustomFonts.black13w600),
                          value: isSelected,
                          onChanged: (bool? checked) {
                            setModalState(() {
                              if (checked == true) {
                                // Logic for handling 'None' mutually exclusively
                                if (item == 'None') {
                                  tempSelected = ['None'];
                                } else {
                                  tempSelected.remove('None');
                                  tempSelected.add(item);
                                }
                              } else {
                                tempSelected.remove(item);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  CustomButton(
                    text: "Done",
                    onPressed: () {
                      onSelectionChanged(List.from(tempSelected));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}