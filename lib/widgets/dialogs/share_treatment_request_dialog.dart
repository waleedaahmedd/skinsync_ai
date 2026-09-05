import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../models/responses/patient_treatment_request_response.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/date_time_utils.dart';
import '../../view_models/patient_treatment_request_view_model.dart';

class ShareTreatmentRequestDialog extends ConsumerStatefulWidget {
  final String patientName;
  final int clinicId;

  const ShareTreatmentRequestDialog({
    super.key,
    this.patientName = 'Jane Cooper',
    required this.clinicId,
  });

  @override
  ConsumerState<ShareTreatmentRequestDialog> createState() =>
      _ShareTreatmentRequestDialogState();
}

class _ShareTreatmentRequestDialogState
    extends ConsumerState<ShareTreatmentRequestDialog> {
  PatientTreatmentRequest? _request;

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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(16)),
      ),
      child: Container(
        width: context.w(360),
        padding: EdgeInsets.all(context.r(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Treatment Request to Share',
              style: CustomFonts.black18w600,
            ),
            SizedBox(height: context.h(8)),
            Text(
              'Select a treatment request of ${widget.patientName} to send into the chat.',
              style: CustomFonts.grey13w400,
            ),
            SizedBox(height: context.h(16)),
            Consumer(
              builder: (_, ref, _) {
                final requests = ref.watch(
                  patientTreatmentRequestProvider.select((s) => s.requests),
                );
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: context.h(10)),
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    final isSelected = _request?.id == req.id;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _request = req;
                        });
                      },
                      borderRadius: BorderRadius.circular(context.r(12)),
                      child: Container(
                        padding: EdgeInsets.all(context.r(12)),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? CustomColors.lightPurpleColor.withValues(
                                  alpha: 0.5,
                                )
                              : CustomColors.whiteColor,
                          borderRadius: BorderRadius.circular(context.r(12)),
                          border: Border.all(
                            color: isSelected
                                ? CustomColors.darkPurple
                                : CustomColors.greyColor,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? CustomColors.darkPurple
                                  : CustomColors.silverColor,
                              size: context.sp(20),
                            ),
                            SizedBox(width: context.w(8)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    req.name ?? 'N/A',
                                    style: CustomFonts.black14w600,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: context.h(4)),
                                  Text(
                                    req.createdAt?.formattedDate ?? 'Recent',
                                    style: CustomFonts.grey12w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: context.h(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel', style: CustomFonts.black14w500),
                ),
                SizedBox(width: context.w(12)),
                ElevatedButton(
                  onPressed: () {
                    if (_request != null) {
                      Navigator.of(context).pop(_request);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.darkPurple,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(16),
                      vertical: context.h(10),
                    ),
                  ),
                  child: Text('Share Request', style: CustomFonts.white14w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
