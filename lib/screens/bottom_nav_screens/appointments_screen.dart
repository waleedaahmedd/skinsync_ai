import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skinsync_ai/models/responses/get_appointment_response.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/view_models/appointment_view_model.dart';
import 'package:skinsync_ai/widgets/scheduled_appointment_tile.dart';

import '../../utills/custom_fonts.dart';
import '../../widgets/app_bar_with_action_icon.dart';

class ApppointmentsScreen extends ConsumerStatefulWidget {
  const ApppointmentsScreen({super.key});

  @override
  ConsumerState<ApppointmentsScreen> createState() =>
      _ApppointmentsScreenState();
}

class _ApppointmentsScreenState extends ConsumerState<ApppointmentsScreen> {
  late final _pagingController = PagingController<int, Appointment>(
    getNextPageKey: (state) {
      final keys = state.keys;
      final pages = state.pages;
      if (keys == null) return 1;
      if (pages != null && pages.last.length < 10) return null;
      return keys.last + 1;
    },
    fetchPage: (pageKey) async {
      log('PAGE KEY: $pageKey');
      final data = await ref
          .read(appointmentProvider.notifier)
          .getAppointment(page: pageKey);
      return data ?? [];
    },
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithActionIcon(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: .start,
        children: [
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: TextField(
              style: CustomFonts.black18w400,

              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search Appointment",
              ),
            ),
          ),
          SizedBox(height: 21.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("My Appointments", style: CustomFonts.black24w600),
                // Container(
                //   decoration: BoxDecoration(
                //     color: CustomColors.greyColor,
                //     borderRadius: BorderRadius.circular(8.r),
                //   ),
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 7.w,
                //     vertical: 8.h,
                //   ),
                //
                //   child: Icon(Icons.tune, color: Colors.black),
                // ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: RefreshIndicator(
              child: PagingListener(
                controller: _pagingController,
                builder: (context, state, fetchNextPage) {
                  return PagedListView(
                    state: state,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom,
                    ),
                    fetchNextPage: fetchNextPage,
                    builderDelegate: PagedChildBuilderDelegate(
                      noItemsFoundIndicatorBuilder: (context) {
                        return Center(
                          child: Text(
                            'No appointments yet',
                            style: CustomFonts.grey16w400,
                          ),
                        );
                      },
                      itemBuilder: (_, Appointment appointment, __) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            mainAxisAlignment: .start,
                            crossAxisAlignment: .start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 30.w,
                                  right: 15.w,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CustomColors.purpleColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 8.h,
                                  ),

                                  child: Text(
                                    appointment.startTime != null
                                        ? appointment.startTimeFormattedTime
                                        : "No time",
                                    style: CustomFonts.white12w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 15.w,
                                    right: 30.w,
                                  ),

                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ScheduledAppointmentTile(
                                      appointment: appointment,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              onRefresh: () async {
                _pagingController.refresh();
              },
            ),
          ),

          // SizedBox(height: 21.h),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: getNextNDays(7).map((dateItem) {
          //       return AppointmentDateWidget(
          //         date: dateItem["date"]!,
          //         day: dateItem["day"]!,
          //       );
          //     }).toList(),
          //   ),
          // ),
          // SizedBox(height: 22.h),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 30.w),
          //
          //   child: Text("Today’s schedule", style: CustomFonts.black20w600),
          // ),
          // SizedBox(height: 28.h),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 30.w),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: CustomColors.purpleColor,
          //       borderRadius: BorderRadius.circular(8.r),
          //     ),
          //     padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),

          //     child: Text("11:00  AM", style: CustomFonts.white12w600),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 30.w),

          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: ScheduledAppointmentTile(),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 30.w),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: CustomColors.purpleColor,
          //       borderRadius: BorderRadius.circular(8.r),
          //     ),
          //     padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),

          //     child: Text("11:00  AM", style: CustomFonts.white12w600),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 30.w),

          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: ScheduledAppointmentTile(),
          //   ),
          // ),
          // // SizedBox(height: 200.h),
        ],
      ),
    );
  }
}
