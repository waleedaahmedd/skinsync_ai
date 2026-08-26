import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/custom_fonts.dart';
import '../view_models/home_view_model.dart';

class ReorderHomeSectionsSheet extends ConsumerWidget {
  const ReorderHomeSectionsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final sections = homeState.sections;

    return Container(
      height: context.h(600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.r(24))),
      ),
      child: Column(
        children: [
          SizedBox(height: context.h(12)),
          Container(
            width: context.w(40),
            height: context.h(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(context.r(2)),
            ),
          ),
          SizedBox(height: context.h(20)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(24)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Reorder Home Sections",
                  style: CustomFonts.black20w600,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(24)),
            child: Text(
              "Drag and drop to rearrange how sections appear on your home screen.",
              style: CustomFonts.grey14w400,
            ),
          ),
          SizedBox(height: context.h(20)),
          Expanded(
            child: ReorderableListView.builder(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              itemCount: sections.length,
              onReorder: (oldIndex, newIndex) {
                ref.read(homeViewModelProvider.notifier).reorderSections(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final section = sections[index];
                return Container(
                  key: ValueKey(section),
                  margin: EdgeInsets.only(bottom: context.h(12)),
                  padding: EdgeInsets.all(context.w(16)),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(context.r(16)),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.drag_handle_rounded, color: Colors.grey.shade400),
                      SizedBox(width: context.w(16)),
                      Text(
                        section.displayName,
                        style: CustomFonts.black16w500,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: context.h(20)),
        ],
      ),
    );
  }
}
