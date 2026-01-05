import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_ai/models/base_state_model.dart';
import 'package:skinsync_ai/models/requests/save_answer_request.dart';
import 'package:skinsync_ai/models/responses/on_boarding_question_response.dart';
import 'package:skinsync_ai/services/api_base_helper.dart';
import 'package:skinsync_ai/services/on_boarding_service.dart';
import '../screens/your_profile_screen.dart';
import 'base_view_model.dart';

// Provider
final onBoardingViewModel =
    NotifierProvider(() {
  final apiBaseHelper = ApiBaseHelper();
  final onBoardingService = OnBoardingService(apiClient: apiBaseHelper);
  return SignUpOnboardingViewModel(onBoardingService: onBoardingService);
});

// ViewModel
class SignUpOnboardingViewModel extends BaseViewModel<SignUpOnboardingState> {
  SignUpOnboardingViewModel({required OnBoardingService onBoardingService})
      : _onBoardingService = onBoardingService,
        super(initialState: const SignUpOnboardingState());

  final OnBoardingService _onBoardingService;
  PageController? _pageController;

  void setPageController(PageController controller) {
    _pageController = controller;
  }

  void onPageChanged(int index) {
    state = state.copyWith(currentPage: index);
  }

  void goToPreviousPage() {
    if (_pageController != null && state.currentPage > 0) {
      _pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onSkipThis(BuildContext context) {
    Navigator.pushReplacementNamed(context, YourProfileScreen.routeName);
  }

 void onNextButton(BuildContext context) {
  if (_pageController == null) return;

  if (state.currentPage < state.totalPages - 1) {
    _pageController!.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  } else {
    Navigator.pushNamed(context, YourProfileScreen.routeName);
  }
}

void setQuesAndOptID({required int questionID, required int optionID}) {
  state = state.copyWith(questionID: questionID, optionID: optionID);
}

  double progressValue() {
 return (state.currentPage + 1) / (state.totalPages == 0 ? 1 : state.totalPages);
  }

  Future<bool?> callOnBoardingQuestionApi() async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final response = await _onBoardingService.questionApi();
      state = state.copyWith(loading: false, onBoardingQues: response);
      return response.isSuccess == true;
    });
  }
  Future<bool?> callSaveAnswerApi({required SaveAnswerRequest saveAnswer}){
    return runSafely(()async{
      state = state.copyWith(isSaveAnswerLoding: true);
      final response = await _onBoardingService.saveAnswerApi(saveAnswerRequest: saveAnswer);
      state = state.copyWith(isSaveAnswerLoding: false);
      return response.isSuccess == true;
    });
  }
  @override
 void onError(String message) {
    state =state.copyWith(loading: false, isSaveAnswerLoding: false);
    super.onError(message);
    EasyLoading.showError(message);
  }
}

// State
@immutable
class SignUpOnboardingState extends BaseStateModel {
 
  final bool isSaveAnswerLoding;
  final int currentPage;
  final OnBoardingQuestionResponse? onBoardingQues;
  final int? questionID;
  final int? optionID; 

  const SignUpOnboardingState({
    super.loading = false,
    this.isSaveAnswerLoding = false,
    super.errorMessage,
    this.currentPage = 0,
    this.onBoardingQues,
    this.questionID,
    this.optionID,
  });
 int get totalPages => (onBoardingQues?.data?.questions?.length ?? 0);
  SignUpOnboardingState copyWith({
    bool? loading,
    String? errorMessage,
    int? currentPage,
    bool? isSaveAnswerLoding, 
    OnBoardingQuestionResponse? onBoardingQues,
     int? questionID,
   int? optionID,
  }) {
    return SignUpOnboardingState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      onBoardingQues: onBoardingQues ?? this.onBoardingQues,
      isSaveAnswerLoding: isSaveAnswerLoding ?? this.isSaveAnswerLoding,
      questionID: questionID ?? this.questionID,
      optionID: optionID ?? this.optionID,
    );
  }
}
