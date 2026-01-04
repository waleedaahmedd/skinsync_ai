import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/models/requests/save_answer_request.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';
import 'package:skinsync_ai/view_models/sign_up_onboarding_view_model.dart';
import 'package:skinsync_ai/widgets/question_title.dart';

class SkinType extends StatelessWidget {
  const SkinType({super.key});

  @override
  Widget build(BuildContext context) {
   int? questionID;
   int? optionID;
    return Consumer(
      builder: (context, ref, _) {
       final question = ref.watch(onBoardingViewModel).onBoardingQues?.data!.questions![ref.read(onBoardingViewModel).currentPage];
       
        if(ref.watch(onBoardingViewModel).loading){
          return Center(child: CircularProgressIndicator(color: CustomColors.purpleColor,));
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 33.h),
              Text(
                question?.questionText ?? "",
                style: CustomFonts.black28w600,
              ),
              SizedBox(height: 39.h),
        
             
              Expanded(
                child: ListView.builder(
                  itemCount: question?.options?.length ?? 0,
                  itemBuilder: (context, index) {
                   final  option = question?.options?[index];

                    return GestureDetector(
                      onTap: (){
                        questionID = question?.iD;
                        optionID = option?.iD;
                        ref.read(onBoardingViewModel.notifier).setQuesAndOptID(questionID: questionID ?? 0, optionID: optionID ?? 0);
                      },
                      child: QuestionTitle(title: option?.optionText ?? "",isSelected: optionID == option?.iD,));
                  },
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: Consumer(
                  builder: (_, ref, _) {
                    return ElevatedButton(
                      onPressed: () {
                        final onBoardingVM =    ref
                            .read(onBoardingViewModel.notifier);
                           
                          final saveAnswer = SaveAnswerRequest(step: "onboarding", answers:[
                            Answer(questionId: questionID ?? 0, optionId: optionID ?? 0)
                          ]) ; 
  
                         if(questionID != null && optionID != null)
                         {
                          onBoardingVM.callSaveAnswerApi(saveAnswer: saveAnswer).then((value){
                               onBoardingVM
                            .onNextButton(context);
                          });
                         }
                      
                      },
                      child: Text("Next"),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }
    );
  }
}
