import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../models/chat_treatment_request_model.dart';
import '../../utils/ai_dummy_data.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';

class ShareTreatmentRequestDialog extends StatefulWidget {
  final String patientName;

  const ShareTreatmentRequestDialog({
    super.key,
    this.patientName = 'Jane Cooper',
  });

  @override
  State<ShareTreatmentRequestDialog> createState() =>
      _ShareTreatmentRequestDialogState();
}

class _ShareTreatmentRequestDialogState
    extends State<ShareTreatmentRequestDialog> {
  late final List<ChatTreatmentRequestModel> _requests;
  ChatTreatmentRequestModel? _selectedRequest;

  @override
  void initState() {
    super.initState();
    _requests = List.from(AiDummyData.dummyTreatmentRequests);
    if (_requests.isNotEmpty) {
      _selectedRequest = _requests.first;
    }
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _requests.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: context.h(10)),
              itemBuilder: (context, index) {
                final req = _requests[index];
                final isSelected = _selectedRequest?.id == req.id;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedRequest = req;
                    });
                  },
                  borderRadius: BorderRadius.circular(context.r(12)),
                  child: Container(
                    padding: EdgeInsets.all(context.r(12)),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? CustomColors.lightPurpleColor.withValues(alpha: 0.5)
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
                                req.name,
                                style: CustomFonts.black14w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: context.h(4)),
                              Text(
                                req.createdAt != null
                                    ? req.createdAt!.substring(0, 10)
                                    : 'Recent',
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
                    if (_selectedRequest != null) {
                      Navigator.of(context).pop(_selectedRequest);
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
