import 'package:skinsync_ai/models/responses/base_response_model.dart';

class OnBoardingQuestionResponse extends BaseResponseModel {
  
  Data? data;

  OnBoardingQuestionResponse({super.isSuccess, super.message, this.data});

  OnBoardingQuestionResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_success'] = this.isSuccess;
    data['message'] = this.message;
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
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
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
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['QuestionText'] = this.questionText;
    if (this.options != null) {
      data['Options'] = this.options!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['QuestionID'] = this.questionID;
    data['OptionText'] = this.optionText;
    return data;
  }
}
