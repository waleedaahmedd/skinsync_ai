class SaveAnswerRequest {
  final String step;
  final List<Answer> answers;

  SaveAnswerRequest({required this.step, required this.answers});

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class Answer {
  final int questionId;
  final int optionId;

  Answer({required this.questionId, required this.optionId});

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'option_id': optionId,
    };
  }
}
