import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_search_field.dart';
import '../widgets/treatment_container.dart';
import '../../utills/custom_fonts.dart';

class SuggestedTreatmentScreen extends ConsumerStatefulWidget {
  const SuggestedTreatmentScreen({super.key});
  static const routeName = "/suggested_treatments_screen";

  @override
  ConsumerState<SuggestedTreatmentScreen> createState() => _SuggestedTreatmentScreenState();
}

class _SuggestedTreatmentScreenState extends ConsumerState<SuggestedTreatmentScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suggestedTreatments = ref.watch(authViewModel).authData?.dashboard?.suggestedTreatments ?? [];
    
    final filteredTreatments = suggestedTreatments.where((t) {
      if (_searchQuery.isEmpty) return true;
      return t.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
    }).toList();

    return Scaffold(
      appBar: const CustomAppBar(showTitle: true, title: "Suggested Treatments"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h),
                CustomSearchField(
                  controller: _searchController,
                  hintText: "Search Treatment...",
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            child: Text("Clinical Suggestions", style: CustomFonts.black24w600),
          ),
          SizedBox(height: 15.h),
          Expanded(
            child: filteredTreatments.isEmpty
                ? _buildEmptyState()
                : AnimationLimiter(
                    key: ValueKey('suggested_treatments_list_$_searchQuery'),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      scrollDirection: Axis.vertical,
                      itemCount: filteredTreatments.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 600),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: TreatmentContainer(
                                  treatments: filteredTreatments[index],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60.sp, color: Colors.grey.shade400),
          SizedBox(height: 16.h),
          Text(
            _searchQuery.isEmpty ? "No suggested treatments found" : "No treatments match your search",
            style: CustomFonts.grey800_16w600,
          ),
        ],
      ),
    );
  }
}
