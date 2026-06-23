import 'base_response_model.dart';

class OnBoardingQuestionResponse extends BaseResponseModel {
  Data? data;

  OnBoardingQuestionResponse({super.status, super.message, this.data});

  OnBoardingQuestionResponse.fromJson(Map<String, dynamic> json) {
    status = json['is_success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_success'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Questions>? questions;

  Data({this.questions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int? iD;
  String? questionText;
  List<Options>? options;

  Questions({this.iD, this.questionText, this.options});

  Questions.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    questionText = json['QuestionText'];
    if (json['Options'] != null) {
      options = <Options>[];
      json['Options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['QuestionText'] = questionText;
    if (options != null) {
      data['Options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int? iD;
  int? questionID;
  String? optionText;

  Options({this.iD, this.questionID, this.optionText});

  Options.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    questionID = json['QuestionID'];
    optionText = json['OptionText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['QuestionID'] = questionID;
    data['OptionText'] = optionText;
    return data;
  }
}
