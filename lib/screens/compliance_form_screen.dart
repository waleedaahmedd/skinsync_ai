import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/forms_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/horizontal_empty_state.dart';
import 'pdf_viewer_screen.dart';

class ComplianceFormsScreen extends ConsumerWidget {
  const ComplianceFormsScreen({super.key});

  static const String routeName = "/ComplianceFormsScreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formsState = ref.watch(formsViewModel);
    final complianceDocs = formsState.complianceDocuments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Compliance Forms"),
      body: formsState.loading
          ? const Center(child: AppLoader())
          : complianceDocs.isEmpty
              ? const Center(
                  child: HorizontalEmptyState(
                    icon: Iconsax.document_text,
                    title: "No Compliance Forms",
                    subtitle: "Compliance documents will appear here once available.",
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.all(context.w(20)),
                  itemCount: complianceDocs.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: context.h(16)),
                  itemBuilder: (context, index) {
                    final doc = complianceDocs[index];
                    return InkWell(
                      onTap: () {
                        if (doc.url != null && doc.url!.isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            PdfViewerScreen.routeName,
                            arguments: {
                              "title": doc.title ?? "Compliance Form",
                              "url": doc.url,
                            },
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(context.r(16)),
                      child: Container(
                        padding: EdgeInsets.all(context.w(16)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(context.r(16)),
                          border: Border.all(
                            color: CustomColors.greyColor.withValues(alpha: 0.5),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(context.w(10)),
                              decoration: BoxDecoration(
                                color: CustomColors.purpleColor
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.document_text,
                                color: CustomColors.purpleColor,
                                size: context.w(24),
                              ),
                            ),
                            SizedBox(width: context.w(16)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.title ?? 'Compliance Form',
                                    style: CustomFonts.black16w600,
                                  ),
                                  if (doc.globalSku != null) ...[
                                    SizedBox(height: context.h(4)),
                                    Text(
                                      "SKU: ${doc.globalSku}",
                                      style: CustomFonts.grey14w400,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.grey.shade400,
                              size: context.sp(24),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

