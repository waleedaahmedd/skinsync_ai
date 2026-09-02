// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:showcaseview/showcaseview.dart';
//
// import '../../main.dart';
// import '../../utils/color_constant.dart';
// import '../../utils/custom_fonts.dart';
// import '../../utils/enums.dart';
// import '../../utils/onboarding_descriptions.dart';
// import '../../view_models/auth_view_model.dart';
// import '../../view_models/bottom_nav_view_model.dart';
// import '../../view_models/home_view_model.dart';
// import '../../widgets/app_bar_with_action_icon.dart';
// import '../../widgets/appointment_card.dart';
// import '../../widgets/discount_card.dart';
// import '../../widgets/grey_container.dart';
// import '../../widgets/heading_with_right_arrow.dart';
// import '../../widgets/home_horizontal_sections.dart';
// import '../../widgets/points_earn_card.dart';
// import '../../widgets/requested_clinic_treatment_widget.dart';
// import '../../widgets/treatment_container.dart';
// import '../appointment_detail_screen.dart';
// import '../doctors_screen.dart';
// import '../journey_clinics_screen.dart';
// import '../notification_screen.dart';
// import '../patient_treatment_requests_screen.dart';
// import '../shared_treatment_requests_screen.dart';
// import 'appointments_screen.dart';
//
// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});
//   static const String routeName = "HomeScreen";
//
//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final GlobalKey _infoKey = GlobalKey();
//   final GlobalKey _reorderKey = GlobalKey();
//   final GlobalKey _notificationKey = GlobalKey();
//   final GlobalKey _requestsKey = GlobalKey();
//   final GlobalKey _pointsKey = GlobalKey();
//   final GlobalKey _simulationsKey = GlobalKey();
//   final GlobalKey _appointmentsKey = GlobalKey();
//   final GlobalKey _treatmentsKey = GlobalKey();
//   final GlobalKey _doctorsKey = GlobalKey();
//   final GlobalKey _clinicsKey = GlobalKey();
//   final GlobalKey _promotionsKey = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//     // Tour is triggered manually by clicking the info button
//   }
//
//   void _startTour(BuildContext context) {
//     ShowcaseView.startShowCase(context, [
//       _infoKey,
//       _reorderKey,
//       _notificationKey,
//       _requestsKey,
//       _pointsKey,
//       _simulationsKey,
//       _appointmentsKey,
//       _treatmentsKey,
//       _doctorsKey,
//       _clinicsKey,
//       _promotionsKey,
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Promotions are still static as no API endpoint provides them yet
//     const int promotionsCount =
//         0; // Set to 0 to show empty state if not available
//
//     final authData = ref.watch(authViewModel).authData;
//     final dashboard = authData?.dashboard;
//     final appointments = dashboard?.appointments ?? [];
//     final homeState = ref.watch(homeViewModelProvider);
//     final sections = homeState.sections;
//     final isReorderMode = homeState.isReorderMode;
//
//     return ShowcaseView.register(
//       onFinish: () {
//         debugPrint("Onboarding tour finished");
//       },
//       builder: (context) => Scaffold(
//         backgroundColor: Colors.grey.shade50,
//         appBar: AppBarWithActionIcon(
//           action: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (!isReorderMode) ...[
//                 Showcase(
//                   key: _infoKey,
//                   title: OnboardingDescriptions.infoTitle,
//                   description: OnboardingDescriptions.infoDesc,
//                   onBarrierClick: () => ShowcaseView.dismiss(context),
//                   child: GreyContainer(
//                     icon: Icons.info_outline,
//                     onTap: () => _startTour(context),
//                   ),
//                 ),
//                 SizedBox(width: context.w(12)),
//               ],
//               if (isReorderMode)
//                 TextButton(
//                   onPressed: () => ref
//                       .read(homeViewModelProvider.notifier)
//                       .toggleReorderMode(),
//                   child: Text(
//                     "Done",
//                     style: CustomFonts.darkPurple12w600.copyWith(
//                       fontSize: context.sp(14),
//                     ),
//                   ),
//                 )
//               else
//                 Showcase(
//                   key: _reorderKey,
//                   title: OnboardingDescriptions.reorderTitle,
//                   description: OnboardingDescriptions.reorderDesc,
//                   onBarrierClick: () => ShowcaseView.dismiss(context),
//                   child: GreyContainer(
//                     icon: Icons.sort_rounded,
//                     onTap: () => ref
//                         .read(homeViewModelProvider.notifier)
//                         .toggleReorderMode(),
//                   ),
//                 ),
//               SizedBox(width: context.w(12)),
//               Showcase(
//                 key: _notificationKey,
//                 title: OnboardingDescriptions.notificationTitle,
//                 description: OnboardingDescriptions.notificationDesc,
//                 onBarrierClick: () => ShowcaseView.dismiss(context),
//                 child: GreyContainer(
//                   icon: Icons.notifications_none_outlined,
//                   onTap: () {
//                     Navigator.of(
//                       context,
//                     ).pushNamed(NotificationScreen.routeName);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: SafeArea(
//           child: ReorderableListView(
//             proxyDecorator: (child, index, animation) =>
//                 Material(color: Colors.transparent, child: child),
//             physics: const BouncingScrollPhysics(),
//             padding: EdgeInsets.only(
//               top: context.h(22),
//               bottom: context.h(100),
//             ),
//             onReorderItem: (oldIndex, newIndex) {
//               ref
//                   .read(homeViewModelProvider.notifier)
//                   .reorderSections(oldIndex, newIndex);
//             },
//             buildDefaultDragHandles:
//                 false, // We'll show handles only in edit mode
//             children: sections.map((section) {
//               final Widget sectionWidget;
//               switch (section) {
//                 case HomeSection.points:
//                   sectionWidget = isDeploymentMode
//                       ? const SizedBox.shrink()
//                       : Showcase(
//                           key: _pointsKey,
//                           title: OnboardingDescriptions.pointsTitle,
//                           description: OnboardingDescriptions.pointsDesc,
//                           onBarrierClick: () => ShowcaseView.dismiss(context),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: context.w(24),
//                             ),
//                             child: Column(
//                               children: [
//                                 const PointsEarnCard(),
//                                 SizedBox(height: context.h(28)),
//                               ],
//                             ),
//                           ),
//                         );
//                   break;
//
//                 case HomeSection.recentSimulations:
//                   sectionWidget = Showcase(
//                     key: _simulationsKey,
//                     title: OnboardingDescriptions.simulationsTitle,
//                     description: OnboardingDescriptions.simulationsDesc,
//                     onBarrierClick: () => ShowcaseView.dismiss(context),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: context.w(24),
//                           ),
//                           child: HeadingWithRightArrow(
//                             title: "Recent Simulations",
//                             onTap: () {
//                               ref
//                                   .read(bottomNavViewModel.notifier)
//                                   .changePage(3);
//                             },
//                           ),
//                         ),
//                         SizedBox(height: context.h(12)),
//                         (dashboard?.recentSimulations?.isEmpty ?? true)
//                             ? _buildHorizontalEmptyState(
//                                 context: context,
//                                 height: context.h(100),
//                                 icon: Icons.auto_awesome_rounded,
//                                 title: "No Recent Simulations",
//                                 subtitle:
//                                     "Your facial AI scans and treatment simulations will appear here.",
//                               )
//                             : SizedBox(
//                                 height: context.h(200),
//                                 child: ListView.builder(
//                                   physics: const BouncingScrollPhysics(),
//                                   scrollDirection: Axis.horizontal,
//                                   clipBehavior: Clip.none,
//                                   itemCount:
//                                       dashboard!.recentSimulations!.length,
//                                   itemBuilder: (context, index) => Padding(
//                                     padding: EdgeInsets.only(
//                                       left: index == 0
//                                           ? context.w(24)
//                                           : context.w(16),
//                                       right:
//                                           index ==
//                                               dashboard
//                                                       .recentSimulations!
//                                                       .length -
//                                                   1
//                                           ? context.w(24)
//                                           : context.w(0),
//                                     ),
//                                     child: DashboardSimulationCard(
//                                       simulation:
//                                           dashboard.recentSimulations![index],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                         SizedBox(height: context.h(12)),
//                       ],
//                     ),
//                   );
//                   break;
//
//                 case HomeSection.sharedTreatmentRequests:
//                   sectionWidget = Showcase(
//                     key: _requestsKey,
//                     title: OnboardingDescriptions.requestsTitle,
//                     description: OnboardingDescriptions.requestsDesc,
//                     onBarrierClick: () => ShowcaseView.dismiss(context),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: context.w(24),
//                           ),
//                           child: HeadingWithRightArrow(
//                             title: "Shared Treatment Requests",
//                             showRightArrow: true,
//                             onTap: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 SharedTreatmentRequestsScreen.routeName,
//                                 arguments: 'Clinic Treatment Requests',
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(height: context.h(12)),
//                         (dashboard?.requestTreatmentClinic?.isEmpty ?? true)
//                             ? _buildHorizontalEmptyState(
//                                 context: context,
//                                 height: context.h(100),
//                                 icon: Icons.request_page_outlined,
//                                 title: "No Shared Treatment Requests",
//                                 subtitle:
//                                     "Shared treatment requests will appear here.",
//                               )
//                             : SizedBox(
//                                 height: context.h(160),
//                                 child: ListView.builder(
//                                   physics: const BouncingScrollPhysics(),
//                                   scrollDirection: Axis.horizontal,
//                                   clipBehavior: Clip.none,
//                                   itemCount:
//                                       dashboard!.requestTreatmentClinic!.length,
//                                   itemBuilder: (context, index) {
//                                     final request = dashboard
//                                         .requestTreatmentClinic![index];
//
//                                     return Padding(
//                                       padding: EdgeInsets.only(
//                                         left: index == 0
//                                             ? context.w(24)
//                                             : context.w(16),
//                                         right:
//                                             index ==
//                                                 dashboard
//                                                         .requestTreatmentClinic!
//                                                         .length -
//                                                     1
//                                             ? context.w(24)
//                                             : context.w(0),
//                                       ),
//                                       child: RequestClinicTreatmentCard(
//                                         data: request,
//                                         onTap: () {
//                                           if (request.id != null) {
//                                             Navigator.pushNamed(
//                                               context,
//                                               PatientTreatmentRequestsScreen
//                                                   .routeName,
//                                               arguments: request.id,
//                                             );
//                                           }
//                                         },
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                         SizedBox(height: context.h(12)),
//                       ],
//                     ),
//                   );
//                   break;
//
//                 case HomeSection.upcomingAppointments:
//                   sectionWidget = Showcase(
//                     key: _appointmentsKey,
//                     title: OnboardingDescriptions.appointmentsTitle,
//                     description: OnboardingDescriptions.appointmentsDesc,
//                     onBarrierClick: () => ShowcaseView.dismiss(context),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: context.w(24),
//                           ),
//                           child: HeadingWithRightArrow(
//                             title: "Upcoming Appointments",
//                             onTap: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 AppointmentsScreen.routeName,
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(height: context.h(12)),
//                         appointments.isEmpty
//                             ? _buildHorizontalEmptyState(
//                                 context: context,
//                                 height: context.h(100),
//                                 icon: Icons.calendar_today_rounded,
//                                 title: "No Upcoming Appointments",
//                                 subtitle:
//                                     "Your scheduled clinical treatments and session details will appear here.",
//                               )
//                             : SizedBox(
//                                 height: context.h(315),
//                                 child: ListView.builder(
//                                   physics: const BouncingScrollPhysics(),
//                                   scrollDirection: Axis.horizontal,
//                                   clipBehavior: Clip.none,
//                                   itemCount: appointments.length,
//                                   itemBuilder: (context, index) {
//                                     final appointment = appointments[index];
//
//                                     return Padding(
//                                       padding: EdgeInsets.only(
//                                         left: index == 0
//                                             ? context.w(24)
//                                             : context.w(16),
//                                         right: index == appointments.length - 1
//                                             ? context.w(24)
//                                             : context.w(0),
//                                       ),
//                                       child: SizedBox(
//                                         width: 0.8.sw,
//                                         child: AppointmentCard(
//                                           isTreatmentListHorizontal: true,
//                                           appointment: appointment,
//                                           onTap: () {
//                                             Navigator.pushNamed(
//                                               context,
//                                               AppointmentDetailScreen.routeName,
//                                               arguments: appointment,
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                         SizedBox(height: context.h(12)),
//                       ],
//                     ),
//                   );
//                   break;
//
//                 case HomeSection.suggestedTreatments:
//                   sectionWidget = Showcase(
//                     key: _treatmentsKey,
//                     title: OnboardingDescriptions.treatmentsTitle,
//                     description: OnboardingDescriptions.treatmentsDesc,
//                     onBarrierClick: () => ShowcaseView.dismiss(context),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: context.w(24),
//                           ),
//                           child: HeadingWithRightArrow(
//                             title: "Suggested Treatments",
//                             onTap: () {
//                               ref
//                                   .read(bottomNavViewModel.notifier)
//                                   .changePage(1);
//                             },
//                           ),
//                         ),
//                         SizedBox(height: context.h(12)),
//                         SizedBox(
//                           height: context.h(180),
//                           child: Consumer(
//                             builder: (context, ref, _) {
//                               final suggestedTreatments =
//                                   dashboard?.suggestedTreatments ?? [];
//
//                               if (suggestedTreatments.isEmpty) {
//                                 return _buildHorizontalEmptyState(
//                                   context: context,
//                                   height: context.h(100),
//                                   icon: Icons.auto_awesome_rounded,
//                                   title: "No Suggested Treatments",
//                                   subtitle:
//                                       "Complete your facial AI scan to receive personalized clinical suggestions.",
//                                 );
//                               }
//
//                               return ListView.builder(
//                                 physics: const BouncingScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: suggestedTreatments.length,
//                                 scrollDirection: Axis.horizontal,
//                                 clipBehavior: Clip.none,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: EdgeInsets.only(
//                                       left: index == 0
//                                           ? context.w(24)
//                                           : context.w(16),
//                                       right:
//                                           index ==
//                                               suggestedTreatments.length - 1
//                                           ? context.w(24)
//                                           : context.w(0),
//                                     ),
//                                     child: TreatmentContainer(
//                                       width: context.w(350),
//                                       treatments: suggestedTreatments[index],
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(height: context.h(12)),
//                       ],
//                     ),
//                   );
//                   break;
//
//                 case HomeSection.topDoctors:
//                   sectionWidget = isDeploymentMode
//                       ? const SizedBox.shrink()
//                       : Showcase(
//                           key: _doctorsKey,
//                           title: OnboardingDescriptions.doctorsTitle,
//                           description: OnboardingDescriptions.doctorsDesc,
//                           onBarrierClick: () => ShowcaseView.dismiss(context),
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: context.w(24),
//                                 ),
//                                 child: HeadingWithRightArrow(
//                                   title: "Top Doctors",
//                                   onTap: () {
//                                     Navigator.pushNamed(
//                                       context,
//                                       DoctorsScreen.routeName,
//                                       arguments: {'isFromHome': true},
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(height: context.h(10)),
//                               (dashboard?.topDoctors?.isEmpty ?? true)
//                                   ? _buildHorizontalEmptyState(
//                                       context: context,
//                                       height: context.h(70),
//                                       icon: Icons.badge_outlined,
//                                       title: "No Specialists Available",
//                                       subtitle:
//                                           "Specialist dermatologists and clinical practitioners will be listed here soon.",
//                                     )
//                                   : SizedBox(
//                                       height: context.h(170),
//                                       child: ListView.builder(
//                                         physics: const BouncingScrollPhysics(),
//                                         scrollDirection: Axis.horizontal,
//                                         clipBehavior: Clip.none,
//                                         itemCount:
//                                             dashboard!.topDoctors!.length,
//                                         itemBuilder: (context, index) =>
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                 left: index == 0
//                                                     ? context.w(24)
//                                                     : context.w(16),
//                                                 right:
//                                                     index ==
//                                                         dashboard
//                                                                 .topDoctors!
//                                                                 .length -
//                                                             1
//                                                     ? context.w(24)
//                                                     : context.w(0),
//                                               ),
//                                               child: DashboardDoctorHomeCard(
//                                                 doctor: dashboard
//                                                     .topDoctors![index],
//                                               ),
//                                             ),
//                                       ),
//                                     ),
//                               SizedBox(height: context.h(12)),
//                             ],
//                           ),
//                         );
//                   break;
//
//                 case HomeSection.topClinics:
//                   sectionWidget = Showcase(
//                     key: _clinicsKey,
//                     title: OnboardingDescriptions.clinicsTitle,
//                     description: OnboardingDescriptions.clinicsDesc,
//                     onBarrierClick: () => ShowcaseView.dismiss(context),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: context.w(24),
//                           ),
//                           child: HeadingWithRightArrow(
//                             title: "Discover Clinics",
//                             onTap: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 JourneyClinicsScreen.routeName,
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(height: context.h(12)),
//                         (dashboard?.topClinics?.isEmpty ?? true)
//                             ? _buildHorizontalEmptyState(
//                                 context: context,
//                                 height: context.h(100),
//                                 icon: Icons.storefront_rounded,
//                                 title: "No Clinics Available",
//                                 subtitle:
//                                     "Top-rated aesthetic clinics and wellness spas will be listed here soon.",
//                               )
//                             : SizedBox(
//                                 height: context.h(200),
//                                 child: ListView.builder(
//                                   physics: const BouncingScrollPhysics(),
//                                   scrollDirection: Axis.horizontal,
//                                   clipBehavior: Clip.none,
//                                   itemCount: dashboard!.topClinics!.length,
//                                   itemBuilder: (context, index) => Padding(
//                                     padding: EdgeInsets.only(
//                                       left: index == 0
//                                           ? context.w(24)
//                                           : context.w(16),
//                                       right:
//                                           index ==
//                                               dashboard.topClinics!.length - 1
//                                           ? context.w(24)
//                                           : context.w(0),
//                                     ),
//                                     child: DashboardClinicHomeCard(
//                                       clinic: dashboard.topClinics![index],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                         SizedBox(height: context.h(12)),
//                       ],
//                     ),
//                   );
//                   break;
//
//                 case HomeSection.promotions:
//                   sectionWidget = isDeploymentMode
//                       ? const SizedBox.shrink()
//                       : Showcase(
//                           key: _promotionsKey,
//                           title: OnboardingDescriptions.promotionsTitle,
//                           description: OnboardingDescriptions.promotionsDesc,
//                           onBarrierClick: () => ShowcaseView.dismiss(context),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: context.w(24),
//                                 ),
//                                 child: Text(
//                                   "Promotions & Discounts",
//                                   style: CustomFonts.black22w600,
//                                 ),
//                               ),
//                               SizedBox(height: context.h(10)),
//                               promotionsCount == 0
//                                   ? _buildHorizontalEmptyState(
//                                       context: context,
//                                       height: context.h(100),
//                                       icon: Icons.local_offer_outlined,
//                                       title: "No Promotions Available",
//                                       subtitle:
//                                           "Exclusive clinical deals, seasonal discounts, and special offers are on their way.",
//                                     )
//                                   : SizedBox(
//                                       height: context.h(200),
//                                       child: ListView.builder(
//                                         physics: const BouncingScrollPhysics(),
//                                         shrinkWrap: true,
//                                         itemCount: promotionsCount,
//                                         scrollDirection: Axis.horizontal,
//                                         clipBehavior: Clip.none,
//                                         padding: EdgeInsets.only(
//                                           top: context.h(10),
//                                           bottom: context.h(40),
//                                           left: context.w(24),
//                                           right: context.w(24),
//                                         ),
//                                         itemBuilder: (context, index) {
//                                           return Padding(
//                                             padding: EdgeInsets.only(
//                                               left: index == 0
//                                                   ? 0
//                                                   : context.w(16),
//                                             ),
//                                             child: const DiscountCard(),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                               SizedBox(height: context.h(10)),
//                             ],
//                           ),
//                         );
//                   break;
//               }
//
//               final item = Container(
//                 key: ValueKey(section),
//                 margin: EdgeInsets.only(
//                   left: isReorderMode ? context.w(48) : 0,
//                 ),
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     AbsorbPointer(
//                       absorbing: isReorderMode,
//                       child: Opacity(
//                         opacity: isReorderMode ? 0.6 : 1.0,
//                         child: sectionWidget,
//                       ),
//                     ),
//                     if (isReorderMode)
//                       Positioned(
//                         left: -context.w(42),
//                         top: context.h(0),
//                         child: Container(
//                           padding: EdgeInsets.all(context.w(6)),
//                           decoration: BoxDecoration(
//                             color: CustomColors.purpleColor.withValues(
//                               alpha: 0.12,
//                             ),
//                             borderRadius: BorderRadius.circular(context.r(10)),
//                             border: Border.all(
//                               color: CustomColors.purpleColor.withValues(
//                                 alpha: 0.2,
//                               ),
//                               width: 1,
//                             ),
//                           ),
//                           child: Icon(
//                             Icons.drag_handle_rounded,
//                             color: CustomColors.purpleColor,
//                             size: context.sp(24),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//
//               if (isReorderMode) {
//                 return ReorderableDragStartListener(
//                   key: ValueKey(section),
//                   index: sections.indexOf(section),
//                   child: item,
//                 );
//               }
//               return item;
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHorizontalEmptyState({
//     required BuildContext context,
//     required double height,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     const myLocalGradient = LinearGradient(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//       colors: [CustomColors.lightPurpleColor, CustomColors.purpleColor],
//     );
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: context.w(24)),
//       child: Container(
//         height: height,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(context.r(24)),
//           gradient: myLocalGradient, // Solid brand gradient background
//           border: Border.all(
//             color: CustomColors.lightPurpleColor.withValues(alpha: 0.4),
//             width: 1.5,
//           ),
//           boxShadow: CustomColors.cardShadow,
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(context.r(22)),
//           child: Stack(
//             children: [
//               // 1. Translucent White Mask Tint Overlay
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.white.withValues(
//                     alpha: 0.85,
//                   ), // Translucent premium white mask
//                 ),
//               ),
//
//               // 2. High-Contrast Content Layer (Sizes the parent container)
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: context.w(16),
//                   vertical: context.h(12),
//                 ),
//                 child: Row(
//                   children: [
//                     // Glowing semi-transparent white circular badge icon
//                     Container(
//                       height: context.w(48),
//                       width: context.w(48),
//                       decoration: BoxDecoration(
//                         color: CustomColors.purpleColor.withValues(alpha: 0.12),
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: CustomColors.purpleColor.withValues(
//                             alpha: 0.15,
//                           ),
//                           width: context.w(1),
//                         ),
//                       ),
//                       child: Center(
//                         child: Icon(
//                           icon,
//                           color: CustomColors.purpleColor,
//                           size: context.sp(22),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: context.w(14)),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             title,
//                             style: CustomFonts.black14w700,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: context.h(4)),
//                           Text(
//                             subtitle,
//                             style: CustomFonts.textGrey13w400,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
///new one
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:showcaseview/showcaseview.dart';
//
// import '../../main.dart';
// import '../../utils/color_constant.dart';
// import '../../utils/custom_fonts.dart';
// import '../../utils/enums.dart';
// import '../../utils/onboarding_descriptions.dart';
// import '../../view_models/auth_view_model.dart';
// import '../../view_models/bottom_nav_view_model.dart';
// import '../../view_models/home_view_model.dart';
// import '../../widgets/app_bar_with_action_icon.dart';
// import '../../widgets/appointment_card.dart';
// import '../../widgets/discount_card.dart';
// import '../../widgets/grey_container.dart';
// import '../../widgets/heading_with_right_arrow.dart';
// import '../../widgets/home_horizontal_sections.dart';
// import '../../widgets/points_earn_card.dart';
// import '../../widgets/requested_clinic_treatment_widget.dart';
// import '../../widgets/treatment_container.dart';
// import '../appointment_detail_screen.dart';
// import '../doctors_screen.dart';
// import '../journey_clinics_screen.dart';
// import '../notification_screen.dart';
// import '../patient_treatment_requests_screen.dart';
// import '../shared_treatment_requests_screen.dart';
// import 'appointments_screen.dart';
//
// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});
//   static const String routeName = "HomeScreen";
//
//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final GlobalKey _infoKey = GlobalKey();
//   final GlobalKey _reorderKey = GlobalKey();
//   final GlobalKey _notificationKey = GlobalKey();
//   final GlobalKey _requestsKey = GlobalKey();
//   final GlobalKey _pointsKey = GlobalKey();
//   final GlobalKey _simulationsKey = GlobalKey();
//   final GlobalKey _appointmentsKey = GlobalKey();
//   final GlobalKey _treatmentsKey = GlobalKey();
//   final GlobalKey _doctorsKey = GlobalKey();
//   final GlobalKey _clinicsKey = GlobalKey();
//   final GlobalKey _promotionsKey = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//     // v5.1.0: registration replaces the old ShowCaseWidget wrapper — this
//     // sets up the tour config (including the global "Skip" button) once,
//     // rather than wrapping the whole screen in a widget every build.
//     ShowcaseView.register(
//       autoPlayDelay: const Duration(seconds: 3),
//       onComplete: (index, key) {
//         debugPrint('Onboarding step $index completed');
//       },
//       // "Next" button shown on every tooltip — this is what advances the
//       // tour now instead of tap-anywhere. Its default onTap (when no
//       // custom onTap is passed) calls ShowcaseView.get().next() for you.
//       // Hidden on the final step (_promotionsKey) since there's nothing
//       // left to advance to.
//       globalTooltipActionConfig: const TooltipActionConfig(
//         alignment: MainAxisAlignment.spaceBetween,
//         actionGap: 12,
//         position: TooltipActionPosition.inside,
//       ),
//       globalTooltipActions: [
//         TooltipActionButton(
//           type: TooltipDefaultActionType.next,
//           name: 'Next',
//           hideActionWidgetForShowcase: [_promotionsKey],
//           backgroundColor: CustomColors.purpleColor,
//           textStyle: const TextStyle(
//             color: Colors.white,
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//       // "Skip" is a separate, always-visible floating button (not a
//       // tooltip action) so it stays reachable regardless of which step
//       // is showing.
//       globalFloatingActionWidget: (showcaseContext) => FloatingActionWidget(
//         right: 16,
//         bottom: 16,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ElevatedButton(
//             onPressed: () {
//               ShowcaseView.get().dismiss();
//               debugPrint('Onboarding tour skipped');
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.grey.shade700,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             child: const Text(
//               'Skip',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     // v5.1.0 requires explicit cleanup of the registered showcase scope.
//     ShowcaseView.get().unregister();
//     super.dispose();
//   }
//
//   void _startTour() {
//     ShowcaseView.get().startShowCase([
//       _infoKey,
//       _reorderKey,
//       _notificationKey,
//       _requestsKey,
//       _pointsKey,
//       _simulationsKey,
//       _appointmentsKey,
//       _treatmentsKey,
//       _doctorsKey,
//       _clinicsKey,
//       _promotionsKey,
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Promotions are still static as no API endpoint provides them yet
//     const int promotionsCount =
//         0; // Set to 0 to show empty state if not available
//
//     final authData = ref.watch(authViewModel).authData;
//     final dashboard = authData?.dashboard;
//     final appointments = dashboard?.appointments ?? [];
//     final homeState = ref.watch(homeViewModelProvider);
//     final sections = homeState.sections;
//     final isReorderMode = homeState.isReorderMode;
//
//     // v5.1.0: no ShowCaseWidget/ShowcaseView.register wrapper around the
//     // tree anymore — Showcase widgets find their registered scope globally,
//     // so build() just returns the Scaffold directly.
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBarWithActionIcon(
//         action: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (!isReorderMode) ...[
//               Showcase(
//                 key: _infoKey,
//                 title: OnboardingDescriptions.infoTitle,
//                 description: OnboardingDescriptions.infoDesc,
//                 onBarrierClick: () => ShowcaseView.get().dismiss(),
//                 child: GreyContainer(
//                   icon: Icons.info_outline,
//                   onTap: () => _startTour(),
//                 ),
//               ),
//               SizedBox(width: context.w(12)),
//             ],
//             if (isReorderMode)
//               TextButton(
//                 onPressed: () => ref
//                     .read(homeViewModelProvider.notifier)
//                     .toggleReorderMode(),
//                 child: Text(
//                   "Done",
//                   style: CustomFonts.darkPurple12w600.copyWith(
//                     fontSize: context.sp(14),
//                   ),
//                 ),
//               )
//             else
//               Showcase(
//                 key: _reorderKey,
//                 title: OnboardingDescriptions.reorderTitle,
//                 description: OnboardingDescriptions.reorderDesc,
//                 onBarrierClick: () => ShowcaseView.get().dismiss(),
//                 child: GreyContainer(
//                   icon: Icons.sort_rounded,
//                   onTap: () => ref
//                       .read(homeViewModelProvider.notifier)
//                       .toggleReorderMode(),
//                 ),
//               ),
//             SizedBox(width: context.w(12)),
//             Showcase(
//               key: _notificationKey,
//               title: OnboardingDescriptions.notificationTitle,
//               description: OnboardingDescriptions.notificationDesc,
//               onBarrierClick: () => ShowcaseView.get().dismiss(),
//               child: GreyContainer(
//                 icon: Icons.notifications_none_outlined,
//                 onTap: () {
//                   Navigator.of(context).pushNamed(NotificationScreen.routeName);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: ReorderableListView(
//           proxyDecorator: (child, index, animation) =>
//               Material(color: Colors.transparent, child: child),
//           physics: const BouncingScrollPhysics(),
//           padding: EdgeInsets.only(top: context.h(22), bottom: context.h(100)),
//           onReorderItem: (oldIndex, newIndex) {
//             ref
//                 .read(homeViewModelProvider.notifier)
//                 .reorderSections(oldIndex, newIndex);
//           },
//           buildDefaultDragHandles:
//               false, // We'll show handles only in edit mode
//           children: sections.map((section) {
//             final Widget sectionWidget;
//             switch (section) {
//               case HomeSection.points:
//                 sectionWidget = isDeploymentMode
//                     ? const SizedBox.shrink()
//                     : Showcase(
//                         key: _pointsKey,
//                         title: OnboardingDescriptions.pointsTitle,
//                         description: OnboardingDescriptions.pointsDesc,
//                         onBarrierClick: () => ShowcaseView.get().dismiss(),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: context.w(24),
//                           ),
//                           child: Column(
//                             children: [
//                               const PointsEarnCard(),
//                               SizedBox(height: context.h(28)),
//                             ],
//                           ),
//                         ),
//                       );
//                 break;
//
//               case HomeSection.recentSimulations:
//                 sectionWidget = Showcase(
//                   key: _simulationsKey,
//                   title: OnboardingDescriptions.simulationsTitle,
//                   description: OnboardingDescriptions.simulationsDesc,
//                   onBarrierClick: () => ShowcaseView.get().dismiss(),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: context.w(24),
//                         ),
//                         child: HeadingWithRightArrow(
//                           title: "Recent Simulations",
//                           onTap: () {
//                             ref.read(bottomNavViewModel.notifier).changePage(3);
//                           },
//                         ),
//                       ),
//                       SizedBox(height: context.h(12)),
//                       (dashboard?.recentSimulations?.isEmpty ?? true)
//                           ? _buildHorizontalEmptyState(
//                               context: context,
//                               height: context.h(100),
//                               icon: Icons.auto_awesome_rounded,
//                               title: "No Recent Simulations",
//                               subtitle:
//                                   "Your facial AI scans and treatment simulations will appear here.",
//                             )
//                           : SizedBox(
//                               height: context.h(200),
//                               child: ListView.builder(
//                                 physics: const BouncingScrollPhysics(),
//                                 scrollDirection: Axis.horizontal,
//                                 clipBehavior: Clip.none,
//                                 itemCount: dashboard!.recentSimulations!.length,
//                                 itemBuilder: (context, index) => Padding(
//                                   padding: EdgeInsets.only(
//                                     left: index == 0
//                                         ? context.w(24)
//                                         : context.w(16),
//                                     right:
//                                         index ==
//                                             dashboard
//                                                     .recentSimulations!
//                                                     .length -
//                                                 1
//                                         ? context.w(24)
//                                         : context.w(0),
//                                   ),
//                                   child: DashboardSimulationCard(
//                                     simulation:
//                                         dashboard.recentSimulations![index],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                       SizedBox(height: context.h(12)),
//                     ],
//                   ),
//                 );
//                 break;
//
//               case HomeSection.sharedTreatmentRequests:
//                 sectionWidget = Showcase(
//                   key: _requestsKey,
//                   title: OnboardingDescriptions.requestsTitle,
//                   description: OnboardingDescriptions.requestsDesc,
//                   onBarrierClick: () => ShowcaseView.get().dismiss(),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: context.w(24),
//                         ),
//                         child: HeadingWithRightArrow(
//                           title: "Shared Treatment Requests",
//                           showRightArrow: true,
//                           onTap: () {
//                             Navigator.pushNamed(
//                               context,
//                               SharedTreatmentRequestsScreen.routeName,
//                               arguments: 'Clinic Treatment Requests',
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: context.h(12)),
//                       (dashboard?.requestTreatmentClinic?.isEmpty ?? true)
//                           ? _buildHorizontalEmptyState(
//                               context: context,
//                               height: context.h(100),
//                               icon: Icons.request_page_outlined,
//                               title: "No Shared Treatment Requests",
//                               subtitle:
//                                   "Shared treatment requests will appear here.",
//                             )
//                           : SizedBox(
//                               height: context.h(160),
//                               child: ListView.builder(
//                                 physics: const BouncingScrollPhysics(),
//                                 scrollDirection: Axis.horizontal,
//                                 clipBehavior: Clip.none,
//                                 itemCount:
//                                     dashboard!.requestTreatmentClinic!.length,
//                                 itemBuilder: (context, index) {
//                                   final request =
//                                       dashboard.requestTreatmentClinic![index];
//
//                                   return Padding(
//                                     padding: EdgeInsets.only(
//                                       left: index == 0
//                                           ? context.w(24)
//                                           : context.w(16),
//                                       right:
//                                           index ==
//                                               dashboard
//                                                       .requestTreatmentClinic!
//                                                       .length -
//                                                   1
//                                           ? context.w(24)
//                                           : context.w(0),
//                                     ),
//                                     child: RequestClinicTreatmentCard(
//                                       data: request,
//                                       onTap: () {
//                                         if (request.id != null) {
//                                           Navigator.pushNamed(
//                                             context,
//                                             PatientTreatmentRequestsScreen
//                                                 .routeName,
//                                             arguments: request.id,
//                                           );
//                                         }
//                                       },
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                       SizedBox(height: context.h(12)),
//                     ],
//                   ),
//                 );
//                 break;
//
//               case HomeSection.upcomingAppointments:
//                 sectionWidget = Showcase(
//                   key: _appointmentsKey,
//                   title: OnboardingDescriptions.appointmentsTitle,
//                   description: OnboardingDescriptions.appointmentsDesc,
//                   onBarrierClick: () => ShowcaseView.get().dismiss(),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: context.w(24),
//                         ),
//                         child: HeadingWithRightArrow(
//                           title: "Upcoming Appointments",
//                           onTap: () {
//                             Navigator.pushNamed(
//                               context,
//                               AppointmentsScreen.routeName,
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: context.h(12)),
//                       appointments.isEmpty
//                           ? _buildHorizontalEmptyState(
//                               context: context,
//                               height: context.h(100),
//                               icon: Icons.calendar_today_rounded,
//                               title: "No Upcoming Appointments",
//                               subtitle:
//                                   "Your scheduled clinical treatments and session details will appear here.",
//                             )
//                           : SizedBox(
//                               height: context.h(315),
//                               child: ListView.builder(
//                                 physics: const BouncingScrollPhysics(),
//                                 scrollDirection: Axis.horizontal,
//                                 clipBehavior: Clip.none,
//                                 itemCount: appointments.length,
//                                 itemBuilder: (context, index) {
//                                   final appointment = appointments[index];
//
//                                   return Padding(
//                                     padding: EdgeInsets.only(
//                                       left: index == 0
//                                           ? context.w(24)
//                                           : context.w(16),
//                                       right: index == appointments.length - 1
//                                           ? context.w(24)
//                                           : context.w(0),
//                                     ),
//                                     child: SizedBox(
//                                       width: 0.8.sw,
//                                       child: AppointmentCard(
//                                         isTreatmentListHorizontal: true,
//                                         appointment: appointment,
//                                         onTap: () {
//                                           Navigator.pushNamed(
//                                             context,
//                                             AppointmentDetailScreen.routeName,
//                                             arguments: appointment,
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                       SizedBox(height: context.h(12)),
//                     ],
//                   ),
//                 );
//                 break;
//
//               case HomeSection.suggestedTreatments:
//                 sectionWidget = Showcase(
//                   key: _treatmentsKey,
//                   title: OnboardingDescriptions.treatmentsTitle,
//                   description: OnboardingDescriptions.treatmentsDesc,
//                   onBarrierClick: () => ShowcaseView.get().dismiss(),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: context.w(24),
//                         ),
//                         child: HeadingWithRightArrow(
//                           title: "Suggested Treatments",
//                           onTap: () {
//                             ref.read(bottomNavViewModel.notifier).changePage(1);
//                           },
//                         ),
//                       ),
//                       SizedBox(height: context.h(12)),
//                       SizedBox(
//                         height: context.h(180),
//                         child: Consumer(
//                           builder: (context, ref, _) {
//                             final suggestedTreatments =
//                                 dashboard?.suggestedTreatments ?? [];
//
//                             if (suggestedTreatments.isEmpty) {
//                               return _buildHorizontalEmptyState(
//                                 context: context,
//                                 height: context.h(100),
//                                 icon: Icons.auto_awesome_rounded,
//                                 title: "No Suggested Treatments",
//                                 subtitle:
//                                     "Complete your facial AI scan to receive personalized clinical suggestions.",
//                               );
//                             }
//
//                             return ListView.builder(
//                               physics: const BouncingScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: suggestedTreatments.length,
//                               scrollDirection: Axis.horizontal,
//                               clipBehavior: Clip.none,
//                               itemBuilder: (context, index) {
//                                 return Padding(
//                                   padding: EdgeInsets.only(
//                                     left: index == 0
//                                         ? context.w(24)
//                                         : context.w(16),
//                                     right:
//                                         index == suggestedTreatments.length - 1
//                                         ? context.w(24)
//                                         : context.w(0),
//                                   ),
//                                   child: TreatmentContainer(
//                                     width: context.w(350),
//                                     treatments: suggestedTreatments[index],
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: context.h(12)),
//                     ],
//                   ),
//                 );
//                 break;
//
//               case HomeSection.topDoctors:
//                 sectionWidget = isDeploymentMode
//                     ? const SizedBox.shrink()
//                     : Showcase(
//                         key: _doctorsKey,
//                         title: OnboardingDescriptions.doctorsTitle,
//                         description: OnboardingDescriptions.doctorsDesc,
//                         onBarrierClick: () => ShowcaseView.get().dismiss(),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: context.w(24),
//                               ),
//                               child: HeadingWithRightArrow(
//                                 title: "Top Doctors",
//                                 onTap: () {
//                                   Navigator.pushNamed(
//                                     context,
//                                     DoctorsScreen.routeName,
//                                     arguments: {'isFromHome': true},
//                                   );
//                                 },
//                               ),
//                             ),
//                             SizedBox(height: context.h(10)),
//                             (dashboard?.topDoctors?.isEmpty ?? true)
//                                 ? _buildHorizontalEmptyState(
//                                     context: context,
//                                     height: context.h(70),
//                                     icon: Icons.badge_outlined,
//                                     title: "No Specialists Available",
//                                     subtitle:
//                                         "Specialist dermatologists and clinical practitioners will be listed here soon.",
//                                   )
//                                 : SizedBox(
//                                     height: context.h(170),
//                                     child: ListView.builder(
//                                       physics: const BouncingScrollPhysics(),
//                                       scrollDirection: Axis.horizontal,
//                                       clipBehavior: Clip.none,
//                                       itemCount: dashboard!.topDoctors!.length,
//                                       itemBuilder: (context, index) => Padding(
//                                         padding: EdgeInsets.only(
//                                           left: index == 0
//                                               ? context.w(24)
//                                               : context.w(16),
//                                           right:
//                                               index ==
//                                                   dashboard.topDoctors!.length -
//                                                       1
//                                               ? context.w(24)
//                                               : context.w(0),
//                                         ),
//                                         child: DashboardDoctorHomeCard(
//                                           doctor: dashboard.topDoctors![index],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                             SizedBox(height: context.h(12)),
//                           ],
//                         ),
//                       );
//                 break;
//
//               case HomeSection.topClinics:
//                 sectionWidget = Showcase(
//                   key: _clinicsKey,
//                   title: OnboardingDescriptions.clinicsTitle,
//                   description: OnboardingDescriptions.clinicsDesc,
//                   onBarrierClick: () => ShowcaseView.get().dismiss(),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: context.w(24),
//                         ),
//                         child: HeadingWithRightArrow(
//                           title: "Discover Clinics",
//                           onTap: () {
//                             Navigator.pushNamed(
//                               context,
//                               JourneyClinicsScreen.routeName,
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: context.h(12)),
//                       (dashboard?.topClinics?.isEmpty ?? true)
//                           ? _buildHorizontalEmptyState(
//                               context: context,
//                               height: context.h(100),
//                               icon: Icons.storefront_rounded,
//                               title: "No Clinics Available",
//                               subtitle:
//                                   "Top-rated aesthetic clinics and wellness spas will be listed here soon.",
//                             )
//                           : SizedBox(
//                               height: context.h(200),
//                               child: ListView.builder(
//                                 physics: const BouncingScrollPhysics(),
//                                 scrollDirection: Axis.horizontal,
//                                 clipBehavior: Clip.none,
//                                 itemCount: dashboard!.topClinics!.length,
//                                 itemBuilder: (context, index) => Padding(
//                                   padding: EdgeInsets.only(
//                                     left: index == 0
//                                         ? context.w(24)
//                                         : context.w(16),
//                                     right:
//                                         index ==
//                                             dashboard.topClinics!.length - 1
//                                         ? context.w(24)
//                                         : context.w(0),
//                                   ),
//                                   child: DashboardClinicHomeCard(
//                                     clinic: dashboard.topClinics![index],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                       SizedBox(height: context.h(12)),
//                     ],
//                   ),
//                 );
//                 break;
//
//               case HomeSection.promotions:
//                 sectionWidget = isDeploymentMode
//                     ? const SizedBox.shrink()
//                     : Showcase(
//                         key: _promotionsKey,
//                         title: OnboardingDescriptions.promotionsTitle,
//                         description: OnboardingDescriptions.promotionsDesc,
//                         onBarrierClick: () => ShowcaseView.get().dismiss(),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: context.w(24),
//                               ),
//                               child: Text(
//                                 "Promotions & Discounts",
//                                 style: CustomFonts.black22w600,
//                               ),
//                             ),
//                             SizedBox(height: context.h(10)),
//                             promotionsCount == 0
//                                 ? _buildHorizontalEmptyState(
//                                     context: context,
//                                     height: context.h(100),
//                                     icon: Icons.local_offer_outlined,
//                                     title: "No Promotions Available",
//                                     subtitle:
//                                         "Exclusive clinical deals, seasonal discounts, and special offers are on their way.",
//                                   )
//                                 : SizedBox(
//                                     height: context.h(200),
//                                     child: ListView.builder(
//                                       physics: const BouncingScrollPhysics(),
//                                       shrinkWrap: true,
//                                       itemCount: promotionsCount,
//                                       scrollDirection: Axis.horizontal,
//                                       clipBehavior: Clip.none,
//                                       padding: EdgeInsets.only(
//                                         top: context.h(10),
//                                         bottom: context.h(40),
//                                         left: context.w(24),
//                                         right: context.w(24),
//                                       ),
//                                       itemBuilder: (context, index) {
//                                         return Padding(
//                                           padding: EdgeInsets.only(
//                                             left: index == 0
//                                                 ? 0
//                                                 : context.w(16),
//                                           ),
//                                           child: const DiscountCard(),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                             SizedBox(height: context.h(10)),
//                           ],
//                         ),
//                       );
//                 break;
//             }
//
//             final item = Container(
//               key: ValueKey(section),
//               margin: EdgeInsets.only(left: isReorderMode ? context.w(48) : 0),
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   AbsorbPointer(
//                     absorbing: isReorderMode,
//                     child: Opacity(
//                       opacity: isReorderMode ? 0.6 : 1.0,
//                       child: sectionWidget,
//                     ),
//                   ),
//                   if (isReorderMode)
//                     Positioned(
//                       left: -context.w(42),
//                       top: context.h(0),
//                       child: Container(
//                         padding: EdgeInsets.all(context.w(6)),
//                         decoration: BoxDecoration(
//                           color: CustomColors.purpleColor.withValues(
//                             alpha: 0.12,
//                           ),
//                           borderRadius: BorderRadius.circular(context.r(10)),
//                           border: Border.all(
//                             color: CustomColors.purpleColor.withValues(
//                               alpha: 0.2,
//                             ),
//                             width: 1,
//                           ),
//                         ),
//                         child: Icon(
//                           Icons.drag_handle_rounded,
//                           color: CustomColors.purpleColor,
//                           size: context.sp(24),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//
//             if (isReorderMode) {
//               return ReorderableDragStartListener(
//                 key: ValueKey(section),
//                 index: sections.indexOf(section),
//                 child: item,
//               );
//             }
//             return item;
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHorizontalEmptyState({
//     required BuildContext context,
//     required double height,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     const myLocalGradient = LinearGradient(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//       colors: [CustomColors.lightPurpleColor, CustomColors.purpleColor],
//     );
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: context.w(24)),
//       child: Container(
//         height: height,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(context.r(24)),
//           gradient: myLocalGradient, // Solid brand gradient background
//           border: Border.all(
//             color: CustomColors.lightPurpleColor.withValues(alpha: 0.4),
//             width: 1.5,
//           ),
//           boxShadow: CustomColors.cardShadow,
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(context.r(22)),
//           child: Stack(
//             children: [
//               // 1. Translucent White Mask Tint Overlay
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.white.withValues(
//                     alpha: 0.85,
//                   ), // Translucent premium white mask
//                 ),
//               ),
//
//               // 2. High-Contrast Content Layer (Sizes the parent container)
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: context.w(16),
//                   vertical: context.h(12),
//                 ),
//                 child: Row(
//                   children: [
//                     // Glowing semi-transparent white circular badge icon
//                     Container(
//                       height: context.w(48),
//                       width: context.w(48),
//                       decoration: BoxDecoration(
//                         color: CustomColors.purpleColor.withValues(alpha: 0.12),
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: CustomColors.purpleColor.withValues(
//                             alpha: 0.15,
//                           ),
//                           width: context.w(1),
//                         ),
//                       ),
//                       child: Center(
//                         child: Icon(
//                           icon,
//                           color: CustomColors.purpleColor,
//                           size: context.sp(22),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: context.w(14)),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             title,
//                             style: CustomFonts.black14w700,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: context.h(4)),
//                           Text(
//                             subtitle,
//                             style: CustomFonts.textGrey13w400,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../main.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/enums.dart';
import '../../utils/onboarding_descriptions.dart';
import '../../view_models/auth_view_model.dart';
import '../../view_models/bottom_nav_view_model.dart';
import '../../view_models/home_view_model.dart';
import '../../widgets/app_bar_with_action_icon.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/discount_card.dart';
import '../../widgets/grey_container.dart';
import '../../widgets/heading_with_right_arrow.dart';
import '../../widgets/home_horizontal_sections.dart';
import '../../widgets/points_earn_card.dart';
import '../../widgets/requested_clinic_treatment_widget.dart';
import '../../widgets/treatment_container.dart';
import '../appointment_detail_screen.dart';
import '../doctors_screen.dart';
import '../journey_clinics_screen.dart';
import '../notification_screen.dart';
import '../patient_treatment_requests_screen.dart';
import '../shared_treatment_requests_screen.dart';
import 'appointments_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "HomeScreen";

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey _infoKey = GlobalKey();
  final GlobalKey _reorderKey = GlobalKey();
  final GlobalKey _notificationKey = GlobalKey();
  final GlobalKey _requestsKey = GlobalKey();
  final GlobalKey _pointsKey = GlobalKey();
  final GlobalKey _simulationsKey = GlobalKey();
  final GlobalKey _appointmentsKey = GlobalKey();
  final GlobalKey _treatmentsKey = GlobalKey();
  final GlobalKey _doctorsKey = GlobalKey();
  final GlobalKey _clinicsKey = GlobalKey();
  final GlobalKey _promotionsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // v5.1.0: registration replaces the old ShowCaseWidget wrapper — this
    // sets up the tour config (including the global "Skip" button) once,
    // rather than wrapping the whole screen in a widget every build.
    ShowcaseView.register(
      autoPlayDelay: const Duration(seconds: 3),
      onComplete: (index, key) {
        debugPrint('Onboarding step $index completed');
      },
      // Skip and Next now live together in ONE floating widget — a single
      // bottom bar with Skip on the left, Next on the right (spaceBetween
      // does the spacer job) — instead of Next being a per-tooltip action
      // that shows up next to the info icon.
      globalFloatingActionWidget: (showcaseContext) => FloatingActionWidget(
        left: 16,
        right: 16,
        bottom: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                ShowcaseView.get().dismiss();
                debugPrint('Onboarding tour skipped');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ShowcaseView.get().next();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.purpleColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // v5.1.0 requires explicit cleanup of the registered showcase scope.
    ShowcaseView.get().unregister();
    super.dispose();
  }

  void _startTour() {
    ShowcaseView.get().startShowCase([
      _infoKey,
      _reorderKey,
      _notificationKey,
      _requestsKey,
      _pointsKey,
      _simulationsKey,
      _appointmentsKey,
      _treatmentsKey,
      _doctorsKey,
      _clinicsKey,
      _promotionsKey,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Promotions are still static as no API endpoint provides them yet
    const int promotionsCount =
        0; // Set to 0 to show empty state if not available

    final authData = ref.watch(authViewModel).authData;
    final dashboard = authData?.dashboard;
    final appointments = dashboard?.appointments ?? [];
    final homeState = ref.watch(homeViewModelProvider);
    final sections = homeState.sections;
    final isReorderMode = homeState.isReorderMode;

    // v5.1.0: no ShowCaseWidget/ShowcaseView.register wrapper around the
    // tree anymore — Showcase widgets find their registered scope globally,
    // so build() just returns the Scaffold directly.
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBarWithActionIcon(
        action: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isReorderMode) ...[
              Showcase(
                key: _infoKey,
                title: OnboardingDescriptions.infoTitle,
                description: OnboardingDescriptions.infoDesc,
                onBarrierClick: () => ShowcaseView.get().dismiss(),
                child: GreyContainer(
                  icon: Icons.info_outline,
                  onTap: () => _startTour(),
                ),
              ),
              SizedBox(width: context.w(12)),
            ],
            if (isReorderMode)
              TextButton(
                onPressed: () => ref
                    .read(homeViewModelProvider.notifier)
                    .toggleReorderMode(),
                child: Text(
                  "Done",
                  style: CustomFonts.darkPurple12w600.copyWith(
                    fontSize: context.sp(14),
                  ),
                ),
              )
            else
              Showcase(
                key: _reorderKey,
                title: OnboardingDescriptions.reorderTitle,
                description: OnboardingDescriptions.reorderDesc,
                onBarrierClick: () => ShowcaseView.get().dismiss(),
                child: GreyContainer(
                  icon: Icons.sort_rounded,
                  onTap: () => ref
                      .read(homeViewModelProvider.notifier)
                      .toggleReorderMode(),
                ),
              ),
            SizedBox(width: context.w(12)),
            Showcase(
              key: _notificationKey,
              title: OnboardingDescriptions.notificationTitle,
              description: OnboardingDescriptions.notificationDesc,
              onBarrierClick: () => ShowcaseView.get().dismiss(),
              child: GreyContainer(
                icon: Icons.notifications_none_outlined,
                onTap: () {
                  Navigator.of(context).pushNamed(NotificationScreen.routeName);
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ReorderableListView(
          proxyDecorator: (child, index, animation) =>
              Material(color: Colors.transparent, child: child),
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: context.h(22), bottom: context.h(100)),
          onReorderItem: (oldIndex, newIndex) {
            ref
                .read(homeViewModelProvider.notifier)
                .reorderSections(oldIndex, newIndex);
          },
          buildDefaultDragHandles:
              false, // We'll show handles only in edit mode
          children: sections.map((section) {
            final Widget sectionWidget;
            switch (section) {
              case HomeSection.points:
                sectionWidget = isDeploymentMode
                    ? const SizedBox.shrink()
                    : Showcase(
                        key: _pointsKey,
                        title: OnboardingDescriptions.pointsTitle,
                        description: OnboardingDescriptions.pointsDesc,
                        onBarrierClick: () => ShowcaseView.get().dismiss(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(24),
                          ),
                          child: Column(
                            children: [
                              const PointsEarnCard(),
                              SizedBox(height: context.h(28)),
                            ],
                          ),
                        ),
                      );
                break;

              case HomeSection.recentSimulations:
                sectionWidget = Showcase(
                  key: _simulationsKey,
                  title: OnboardingDescriptions.simulationsTitle,
                  description: OnboardingDescriptions.simulationsDesc,
                  onBarrierClick: () => ShowcaseView.get().dismiss(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(24),
                        ),
                        child: HeadingWithRightArrow(
                          title: "Recent Simulations",
                          onTap: () {
                            ref.read(bottomNavViewModel.notifier).changePage(3);
                          },
                        ),
                      ),
                      SizedBox(height: context.h(12)),
                      (dashboard?.recentSimulations?.isEmpty ?? true)
                          ? _buildHorizontalEmptyState(
                              context: context,
                              height: context.h(100),
                              icon: Icons.auto_awesome_rounded,
                              title: "No Recent Simulations",
                              subtitle:
                                  "Your facial AI scans and treatment simulations will appear here.",
                            )
                          : SizedBox(
                              height: context.h(200),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
                                itemCount: dashboard!.recentSimulations!.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0
                                        ? context.w(24)
                                        : context.w(16),
                                    right:
                                        index ==
                                            dashboard
                                                    .recentSimulations!
                                                    .length -
                                                1
                                        ? context.w(24)
                                        : context.w(0),
                                  ),
                                  child: DashboardSimulationCard(
                                    simulation:
                                        dashboard.recentSimulations![index],
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: context.h(12)),
                    ],
                  ),
                );
                break;

              case HomeSection.sharedTreatmentRequests:
                sectionWidget = Showcase(
                  key: _requestsKey,
                  title: OnboardingDescriptions.requestsTitle,
                  description: OnboardingDescriptions.requestsDesc,
                  onBarrierClick: () => ShowcaseView.get().dismiss(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(24),
                        ),
                        child: HeadingWithRightArrow(
                          title: "Shared Treatment Requests",
                          showRightArrow: true,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              SharedTreatmentRequestsScreen.routeName,
                              arguments: 'Clinic Treatment Requests',
                            );
                          },
                        ),
                      ),
                      SizedBox(height: context.h(12)),
                      (dashboard?.requestTreatmentClinic?.isEmpty ?? true)
                          ? _buildHorizontalEmptyState(
                              context: context,
                              height: context.h(100),
                              icon: Icons.request_page_outlined,
                              title: "No Shared Treatment Requests",
                              subtitle:
                                  "Shared treatment requests will appear here.",
                            )
                          : SizedBox(
                              height: context.h(160),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
                                itemCount:
                                    dashboard!.requestTreatmentClinic!.length,
                                itemBuilder: (context, index) {
                                  final request =
                                      dashboard.requestTreatmentClinic![index];

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: index == 0
                                          ? context.w(24)
                                          : context.w(16),
                                      right:
                                          index ==
                                              dashboard
                                                      .requestTreatmentClinic!
                                                      .length -
                                                  1
                                          ? context.w(24)
                                          : context.w(0),
                                    ),
                                    child: RequestClinicTreatmentCard(
                                      data: request,
                                      onTap: () {
                                        if (request.id != null) {
                                          Navigator.pushNamed(
                                            context,
                                            PatientTreatmentRequestsScreen
                                                .routeName,
                                            arguments: request.id,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                      SizedBox(height: context.h(12)),
                    ],
                  ),
                );
                break;

              case HomeSection.upcomingAppointments:
                sectionWidget = Showcase(
                  key: _appointmentsKey,
                  title: OnboardingDescriptions.appointmentsTitle,
                  description: OnboardingDescriptions.appointmentsDesc,
                  onBarrierClick: () => ShowcaseView.get().dismiss(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(24),
                        ),
                        child: HeadingWithRightArrow(
                          title: "Upcoming Appointments",
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppointmentsScreen.routeName,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: context.h(12)),
                      appointments.isEmpty
                          ? _buildHorizontalEmptyState(
                              context: context,
                              height: context.h(100),
                              icon: Icons.calendar_today_rounded,
                              title: "No Upcoming Appointments",
                              subtitle:
                                  "Your scheduled clinical treatments and session details will appear here.",
                            )
                          : SizedBox(
                              height: context.h(315),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  final appointment = appointments[index];

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: index == 0
                                          ? context.w(24)
                                          : context.w(16),
                                      right: index == appointments.length - 1
                                          ? context.w(24)
                                          : context.w(0),
                                    ),
                                    child: SizedBox(
                                      width: 0.8.sw,
                                      child: AppointmentCard(
                                        isTreatmentListHorizontal: true,
                                        appointment: appointment,
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppointmentDetailScreen.routeName,
                                            arguments: appointment,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      SizedBox(height: context.h(12)),
                    ],
                  ),
                );
                break;

              case HomeSection.suggestedTreatments:
                sectionWidget = Showcase(
                  key: _treatmentsKey,
                  title: OnboardingDescriptions.treatmentsTitle,
                  description: OnboardingDescriptions.treatmentsDesc,
                  onBarrierClick: () => ShowcaseView.get().dismiss(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(24),
                        ),
                        child: HeadingWithRightArrow(
                          title: "Suggested Treatments",
                          onTap: () {
                            ref.read(bottomNavViewModel.notifier).changePage(1);
                          },
                        ),
                      ),
                      SizedBox(height: context.h(12)),
                      SizedBox(
                        height: context.h(180),
                        child: Consumer(
                          builder: (context, ref, _) {
                            final suggestedTreatments =
                                dashboard?.suggestedTreatments ?? [];

                            if (suggestedTreatments.isEmpty) {
                              return _buildHorizontalEmptyState(
                                context: context,
                                height: context.h(100),
                                icon: Icons.auto_awesome_rounded,
                                title: "No Suggested Treatments",
                                subtitle:
                                    "Complete your facial AI scan to receive personalized clinical suggestions.",
                              );
                            }

                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: suggestedTreatments.length,
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0
                                        ? context.w(24)
                                        : context.w(16),
                                    right:
                                        index == suggestedTreatments.length - 1
                                        ? context.w(24)
                                        : context.w(0),
                                  ),
                                  child: TreatmentContainer(
                                    width: context.w(350),
                                    treatments: suggestedTreatments[index],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: context.h(12)),
                    ],
                  ),
                );
                break;

              case HomeSection.topDoctors:
                sectionWidget = isDeploymentMode
                    ? const SizedBox.shrink()
                    : Showcase(
                        key: _doctorsKey,
                        title: OnboardingDescriptions.doctorsTitle,
                        description: OnboardingDescriptions.doctorsDesc,
                        onBarrierClick: () => ShowcaseView.get().dismiss(),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(24),
                              ),
                              child: HeadingWithRightArrow(
                                title: "Top Doctors",
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    DoctorsScreen.routeName,
                                    arguments: {'isFromHome': true},
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: context.h(10)),
                            (dashboard?.topDoctors?.isEmpty ?? true)
                                ? _buildHorizontalEmptyState(
                                    context: context,
                                    height: context.h(70),
                                    icon: Icons.badge_outlined,
                                    title: "No Specialists Available",
                                    subtitle:
                                        "Specialist dermatologists and clinical practitioners will be listed here soon.",
                                  )
                                : SizedBox(
                                    height: context.h(170),
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      clipBehavior: Clip.none,
                                      itemCount: dashboard!.topDoctors!.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: EdgeInsets.only(
                                          left: index == 0
                                              ? context.w(24)
                                              : context.w(16),
                                          right:
                                              index ==
                                                  dashboard.topDoctors!.length -
                                                      1
                                              ? context.w(24)
                                              : context.w(0),
                                        ),
                                        child: DashboardDoctorHomeCard(
                                          doctor: dashboard.topDoctors![index],
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(height: context.h(12)),
                          ],
                        ),
                      );
                break;

              case HomeSection.topClinics:
                sectionWidget = Showcase(
                  key: _clinicsKey,
                  title: OnboardingDescriptions.clinicsTitle,
                  description: OnboardingDescriptions.clinicsDesc,
                  onBarrierClick: () => ShowcaseView.get().dismiss(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(24),
                        ),
                        child: HeadingWithRightArrow(
                          title: "Discover Clinics",
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              JourneyClinicsScreen.routeName,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: context.h(12)),
                      (dashboard?.topClinics?.isEmpty ?? true)
                          ? _buildHorizontalEmptyState(
                              context: context,
                              height: context.h(100),
                              icon: Icons.storefront_rounded,
                              title: "No Clinics Available",
                              subtitle:
                                  "Top-rated aesthetic clinics and wellness spas will be listed here soon.",
                            )
                          : SizedBox(
                              height: context.h(200),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
                                itemCount: dashboard!.topClinics!.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0
                                        ? context.w(24)
                                        : context.w(16),
                                    right:
                                        index ==
                                            dashboard.topClinics!.length - 1
                                        ? context.w(24)
                                        : context.w(0),
                                  ),
                                  child: DashboardClinicHomeCard(
                                    clinic: dashboard.topClinics![index],
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: context.h(12)),
                    ],
                  ),
                );
                break;

              case HomeSection.promotions:
                sectionWidget = isDeploymentMode
                    ? const SizedBox.shrink()
                    : Showcase(
                        key: _promotionsKey,
                        title: OnboardingDescriptions.promotionsTitle,
                        description: OnboardingDescriptions.promotionsDesc,
                        onBarrierClick: () => ShowcaseView.get().dismiss(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(24),
                              ),
                              child: Text(
                                "Promotions & Discounts",
                                style: CustomFonts.black22w600,
                              ),
                            ),
                            SizedBox(height: context.h(10)),
                            promotionsCount == 0
                                ? _buildHorizontalEmptyState(
                                    context: context,
                                    height: context.h(100),
                                    icon: Icons.local_offer_outlined,
                                    title: "No Promotions Available",
                                    subtitle:
                                        "Exclusive clinical deals, seasonal discounts, and special offers are on their way.",
                                  )
                                : SizedBox(
                                    height: context.h(200),
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: promotionsCount,
                                      scrollDirection: Axis.horizontal,
                                      clipBehavior: Clip.none,
                                      padding: EdgeInsets.only(
                                        top: context.h(10),
                                        bottom: context.h(40),
                                        left: context.w(24),
                                        right: context.w(24),
                                      ),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            left: index == 0
                                                ? 0
                                                : context.w(16),
                                          ),
                                          child: const DiscountCard(),
                                        );
                                      },
                                    ),
                                  ),
                            SizedBox(height: context.h(10)),
                          ],
                        ),
                      );
                break;
            }

            final item = Container(
              key: ValueKey(section),
              margin: EdgeInsets.only(left: isReorderMode ? context.w(48) : 0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AbsorbPointer(
                    absorbing: isReorderMode,
                    child: Opacity(
                      opacity: isReorderMode ? 0.6 : 1.0,
                      child: sectionWidget,
                    ),
                  ),
                  if (isReorderMode)
                    Positioned(
                      left: -context.w(42),
                      top: context.h(0),
                      child: Container(
                        padding: EdgeInsets.all(context.w(6)),
                        decoration: BoxDecoration(
                          color: CustomColors.purpleColor.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(context.r(10)),
                          border: Border.all(
                            color: CustomColors.purpleColor.withValues(
                              alpha: 0.2,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.drag_handle_rounded,
                          color: CustomColors.purpleColor,
                          size: context.sp(24),
                        ),
                      ),
                    ),
                ],
              ),
            );

            if (isReorderMode) {
              return ReorderableDragStartListener(
                key: ValueKey(section),
                index: sections.indexOf(section),
                child: item,
              );
            }
            return item;
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHorizontalEmptyState({
    required BuildContext context,
    required double height,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    const myLocalGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [CustomColors.lightPurpleColor, CustomColors.purpleColor],
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(24)),
          gradient: myLocalGradient, // Solid brand gradient background
          border: Border.all(
            color: CustomColors.lightPurpleColor.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: CustomColors.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.r(22)),
          child: Stack(
            children: [
              // 1. Translucent White Mask Tint Overlay
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(
                    alpha: 0.85,
                  ), // Translucent premium white mask
                ),
              ),

              // 2. High-Contrast Content Layer (Sizes the parent container)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(12),
                ),
                child: Row(
                  children: [
                    // Glowing semi-transparent white circular badge icon
                    Container(
                      height: context.w(48),
                      width: context.w(48),
                      decoration: BoxDecoration(
                        color: CustomColors.purpleColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: CustomColors.purpleColor.withValues(
                            alpha: 0.15,
                          ),
                          width: context.w(1),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: CustomColors.purpleColor,
                          size: context.sp(22),
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(14)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: CustomFonts.black14w700,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: context.h(4)),
                          Text(
                            subtitle,
                            style: CustomFonts.textGrey13w400,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
