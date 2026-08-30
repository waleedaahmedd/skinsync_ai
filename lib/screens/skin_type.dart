import 'package:material_ui/material_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../models/requests/save_answer_request.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/sign_up_onboarding_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_button.dart';
import '../widgets/question_title.dart';

class SkinType extends StatelessWidget {
  const SkinType({super.key});

  @override
  Widget build(BuildContext context) {
    int? questionID;
    int? optionID;
    return Consumer(
      builder: (context, ref, _) {
        final question = ref
            .watch(onBoardingViewModel)
            .onBoardingQues
            ?.data!
            .questions![ref.read(onBoardingViewModel).currentPage];

        if (ref.watch(onBoardingViewModel).loading) {
          return const Center(
            child: CircularProgressIndicator(color: CustomColors.purpleColor),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(33)),
              Text(
                question?.questionText ?? "",
                style: CustomFonts.black28w600,
              ),
              SizedBox(height: context.h(39)),

              Expanded(
                child: ListView.builder(
                  itemCount: question?.options?.length ?? 0,
                  itemBuilder: (context, index) {
                    final option = question?.options?[index];

                    return GestureDetector(
                      onTap: () {
                        questionID = question?.iD;
                        optionID = option?.iD;
                        ref
                            .read(onBoardingViewModel.notifier)
                            .setQuesAndOptID(
                              questionID: questionID ?? 0,
                              optionID: optionID ?? 0,
                            );
                      },
                      child: QuestionTitle(
                        title: option?.optionText ?? "",
                        isSelected: optionID == option?.iD,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: context.h(20)),
              SizedBox(
                width: double.infinity,
                child: Consumer(
                  builder: (_, ref, _) {
                    final loading = ref
                        .watch(onBoardingViewModel)
                        .isSaveAnswerLoding;
                    if (loading) {
                      return const AppLoader();
                    }
                    return CustomButton(
                      onPressed: () {
                        final onBoardingVM = ref.read(
                          onBoardingViewModel.notifier,
                        );

                        final saveAnswer = SaveAnswerRequest(
                          step: "onboarding",
                          answers: [
                            Answer(
                              questionId: questionID ?? 0,
                              optionId: optionID ?? 0,
                            ),
                          ],
                        );
                        if (questionID == null || optionID == null) {
                          EasyLoading.showError('Please select an option');
                          return;
                        }
                        if (questionID != null && optionID != null) {
                          onBoardingVM
                              .callSaveAnswerApi(saveAnswer: saveAnswer)
                              .then((value) {
                                onBoardingVM.onNextButton(context);
                              });
                        }
                      },
                      text: "Next",
                    );
                  },
                ),
              ),
              SizedBox(height: context.h(20)),
            ],
          ),
        );
      },
    );
  }
}
