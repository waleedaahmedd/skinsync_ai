import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../models/responses/consent_form_response.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/forms_view_model.dart';
import '../widgets/custom_app_bar.dart';
import 'legal_document_screen.dart';

class ConsentFormsScreen extends ConsumerStatefulWidget {
  const ConsentFormsScreen({super.key});

  static const String routeName = "/ConsentFormsScreen";

  @override
  ConsumerState<ConsentFormsScreen> createState() =>
      _ConsentFormsScreenState();
}

class _ConsentFormsScreenState extends ConsumerState<ConsentFormsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(formsViewModel.notifier).fetchForms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(formsViewModel);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "Consent Forms"),
        body: Column(
          children: [
            SizedBox(height: context.h(8)),
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.shade500,
              indicatorColor: CustomColors.lightBlueColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: CustomFonts.black16w600,
              unselectedLabelStyle: CustomFonts.grey16w500,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: "Unsigned Forms"),
                Tab(text: "Signed Forms"),
              ],
            ),
            Expanded(
              child: state.loading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      children: [
                        _ConsentListView(documents: state.unSignDocument),
                        _ConsentListView(
                          documents: state.signDocument,
                          isAlreadySigned: true,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsentListView extends StatelessWidget {
  final List<Document> documents;
  final bool isAlreadySigned;

  const _ConsentListView({required this.documents, this.isAlreadySigned = false});

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return Center(
        child: Text(
          "No forms found",
          style: CustomFonts.grey16w400,
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(context.w(20)),
      itemCount: documents.length,
      separatorBuilder: (context, index) => SizedBox(height: context.h(16)),
      itemBuilder: (context, index) {
        final document = documents[index];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              LegalDocumentScreen.routeName,
              arguments: LegalDocumentArgs(
                title: document.title ?? '',
                url: document.url,
                storageFileName: 'signed_form_${document.id}.pdf',
                formId: document.id,
                isAlreadySigned: isAlreadySigned,
              ),
            );
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
                    color: CustomColors.purpleColor.withValues(alpha: 0.1),
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
                        document.title ?? 'Untitled Document',
                        style: CustomFonts.black16w600,
                      ),
                      if (document.type != null) ...[
                        SizedBox(height: context.h(4)),
                        Text(
                          document.type!,
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
    );
  }
}