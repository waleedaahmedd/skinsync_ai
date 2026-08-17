import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/patient_treatment_request_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/medical_disclaimer_banner.dart';
import '../widgets/simulation_card.dart';

class PatientTreatmentRequestsScreen extends ConsumerStatefulWidget {
  final int clinicId;
  const PatientTreatmentRequestsScreen({super.key, required this.clinicId});

  static const String routeName = '/PatientTreatmentRequestsScreen';

  @override
  ConsumerState<PatientTreatmentRequestsScreen> createState() =>
      _PatientTreatmentRequestsScreenState();
}

class _PatientTreatmentRequestsScreenState
    extends ConsumerState<PatientTreatmentRequestsScreen> {
  String _selectedSubTab = "Simulation";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(patientTreatmentRequestProvider.notifier)
          .fetchRequests(clinicId: widget.clinicId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patientTreatmentRequestProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showTitle: true,
        title: "Treatment Requests",
      ),
      body: state.loading
          ? const Center(child: AppLoader())
          : state.requests.isEmpty
          ? Center(
              child: Text(
                state.errorMessage ?? "No treatment requests found",
                style: CustomFonts.grey16w400,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: context.h(10),
                    bottom: context.h(20),
                    left: context.w(24),
                    right: context.w(24),
                  ),
                  child: Row(
                    children: [
                      _buildSubTabButton("Simulation"),
                      SizedBox(width: context.w(12)),
                      _buildSubTabButton("Treatments"),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.requests.length,
                    itemBuilder: (context, index) {
                      final request = state.requests[index];
                      final sim = request.simulation;

                      if (sim == null) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0) const MedicalDisclaimerBanner(),
                          Padding(
                            padding: EdgeInsets.only(
                              top: context.h(16),
                              bottom: context.h(12),
                              left: context.w(4),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: context.r(24),
                                  backgroundColor: CustomColors.greyColor
                                      .withValues(alpha: 0.2),
                                  backgroundImage:
                                      request.image != null &&
                                              request.image!.isNotEmpty
                                          ? NetworkImage(request.image!)
                                          : null,
                                  child: request.image == null ||
                                          request.image!.isEmpty
                                      ? const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                          size: 28,
                                        )
                                      : null,
                                ),
                                SizedBox(width: context.w(12)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        request.patientName ??
                                            "Unnamed Patient",
                                        style: CustomFonts.black18w600,
                                      ),
                                      Text(
                                        request.patientEmail ?? "",
                                        style: CustomFonts.grey14w400,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SimulationCard(
                            sim: sim,
                            showActionButton: false,
                            showImages: _selectedSubTab == "Simulation",
                            showTreatments: _selectedSubTab == "Treatments",
                          ),
                          SizedBox(height: context.h(20)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSubTabButton(String title) {
    final isSelected = _selectedSubTab == title;

    return Expanded(
      child: CustomButton(
        text: title,
        onPressed: () {
          setState(() {
            _selectedSubTab = title;
          });
        },
        height: context.h(45),
        borderRadius: context.r(100),
        isBorder: !isSelected,
        textColor: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}
