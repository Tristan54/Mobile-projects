class Question {

  String questionText;
  bool questionAnswer;

  Question({String text, bool answer}){
    questionText = text;
    questionAnswer = answer;
  }

  @override
  String toString() {
    return 'Question{questionText: $questionText, questionAnswer: $questionAnswer}';
  }

}