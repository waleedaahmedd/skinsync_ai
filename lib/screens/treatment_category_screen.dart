import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skinsync_ai/models/dummy_list_model.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/treatments_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/treatment_container.dart';

class TreatmentCategoryScreen extends StatefulWidget {
  final List<CategoryModel> categories;
  final String title;

  const TreatmentCategoryScreen({
    super.key,
    required this.categories,
    required this.title,
  });

  static const String routeName = '/TreatmentCategoryScreen';

  @override
  State<TreatmentCategoryScreen> createState() => _TreatmentCategoryScreenState();
}

class _TreatmentCategoryScreenState extends State<TreatmentCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter categories based on search query
    final filteredCategories = widget.categories.where((category) {
      final name = category.name.toLowerCase();
      final desc = (category.shortDescription ?? "").toLowerCase();
      return name.contains(_searchQuery) || desc.contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Professional MedSpa Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300, width: 1),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16.sp,
                            color: CustomColors.blackColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: CustomFonts.black24w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Search Field with Matching MedSpa Premium Design
                  TextField(
                    controller: _searchController,
                    style: CustomFonts.black18w400,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      hintText: "Search categories...",
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: CustomColors.greyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: CustomColors.purpleColor),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),

            // Category Listing using Reusable Adaptive TreatmentContainer
            Expanded(
              child: filteredCategories.isEmpty
                  ? _buildEmptyResultsPlaceholder()
                  : AnimationLimiter(
                      key: ValueKey('category_list_${widget.title}'),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredCategories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == filteredCategories.length) {
                            return SizedBox(height: 110.h); // Provide padding for floating items
                          }

                          final category = filteredCategories[index];

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 600),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: TreatmentContainer(
                                    customTitle: category.name,
                                    customSubtitle: category.shortDescription ?? "",
                                    customImageUrl: category.image ?? "",
                                    customOnTap: () {
                                      if (category.subCategories.isNotEmpty) {
                                        // Recursively open another category screen if has children
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TreatmentCategoryScreen(
                                              categories: category.subCategories,
                                              title: category.name,
                                            ),
                                          ),
                                        );
                                      } else {
                                        // If no children (leaf node), open the Treatment Screen!
                                        Navigator.pushNamed(
                                          context,
                                          TreatmentsScreen.routeName,
                                          arguments: 'all',
                                        );
                                      }
                                    },
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
      ),
    );
  }

  Widget _buildEmptyResultsPlaceholder() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 70.sp, color: Colors.grey.shade400),
            SizedBox(height: 15.h),
            Text(
              "No Categories Found",
              style: CustomFonts.black20w600.copyWith(color: Colors.grey.shade700),
            ),
            SizedBox(height: 5.h),
            Text(
              "We couldn't find any categories matching your search criteria.",
              textAlign: TextAlign.center,
              style: CustomFonts.grey14w400,
            ),
          ],
        ),
      ),
    );
  }
}
