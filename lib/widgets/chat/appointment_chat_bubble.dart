import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../models/responses/messages_response.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';

class AppointmentChatBubble extends StatelessWidget {
  final Message message;

  const AppointmentChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    // final data = message.appointmentData;

    return Container(
      constraints: BoxConstraints(maxWidth: context.w(340)),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(14),
      ),
      decoration: BoxDecoration(
        color: CustomColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.r(16)),
          topRight: Radius.circular(context.r(16)),
          bottomLeft: Radius.circular(isMe ? context.r(16) : context.r(2)),
          bottomRight: Radius.circular(isMe ? context.r(2) : context.r(16)),
        ),
        border: Border.all(
          color: CustomColors.blueColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.r(6)),
                    decoration: const BoxDecoration(
                      color: CustomColors.greyColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      size: context.sp(16),
                      color: CustomColors.blueColor,
                    ),
                  ),
                  SizedBox(width: context.w(8)),
                  Text('Appointment Details', style: CustomFonts.black13w600),
                ],
              ),
              // if (data != null)
              //   Container(
              //     padding: EdgeInsets.symmetric(
              //       horizontal: context.w(8),
              //       vertical: context.h(2),
              //     ),
              //     decoration: BoxDecoration(
              //       color: const Color(0xFF10B981).withValues(alpha: 0.1),
              //       borderRadius: BorderRadius.circular(context.r(12)),
              //     ),
              //     child: Text(
              //       data.status,
              //       style: TextStyle(
              //         fontSize: context.sp(11),
              //         fontWeight: FontWeight.w600,
              //         color: const Color(0xFF10B981),
              //         fontFamily: 'Degular',
              //       ),
              //     ),
              //   ),
            ],
          ),
          SizedBox(height: context.h(10)),
          if (message.content?.isNotEmpty ?? false) ...[
            Text(message.content!, style: CustomFonts.black14w400),
            SizedBox(height: context.h(10)),
          ],
          // if (data != null) ...[
          //   Container(
          //     padding: EdgeInsets.all(context.r(12)),
          //     decoration: BoxDecoration(
          //       color: CustomColors.greyColor,
          //       borderRadius: BorderRadius.circular(context.r(10)),
          //     ),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         _buildDetailRow(context, 'Service:', data.serviceName),
          //         SizedBox(height: context.h(4)),
          //         _buildDetailRow(
          //             context, 'Date & Time:', '${data.date} at ${data.time}'),
          //         SizedBox(height: context.h(4)),
          //         _buildDetailRow(context, 'Provider:', data.practitionerName),
          //       ],
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }

  // Widget _buildDetailRow(BuildContext context, String label, String value) {
  //   return Row(
  //     children: [
  //       SizedBox(
  //         width: context.w(80),
  //         child: Text(
  //           label,
  //           style: CustomFonts.grey12w400,
  //         ),
  //       ),
  //       Expanded(
  //         child: Text(
  //           value,
  //           style: CustomFonts.black12w600,
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
