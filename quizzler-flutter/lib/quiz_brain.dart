import 'package:flutter/material.dart';
import 'question.dart';

class Quizbrain{

  List<Question> _questions = [
    Question(text: 'You can lead a cow down stairs but not up stairs.', answer: false),
    Question(text: 'Approximately one quarter of human bones are in the feet.', answer: true),
    Question(text: 'A slug\'s blood is green.', answer: true),
    Question(text: 'Buzz Aldrin\'s mother\'s maiden name was \"Moon\".', answer: true),
    Question(text: 'It is illegal to pee in the Ocean in Portugal.', answer: true),
    Question(text: 'No piece of square dry paper can be folded in half more than 7 times.', answer: false),
    Question(text: 'In London, UK, if you happen to die in the House of Parliament, you are technically entitled to a state funeral, because the building is considered too sacred a place.', answer: true),
    Question(text: 'The loudest sound produced by any animal is 188 decibels. That animal is the African Elephant.', answer: false),
    Question(text: 'The total surface area of two human lungs is approximately 70 square metres.', answer: true),
    Question(text: 'Google was originally called \"Backrub\".', answer: true),
    Question(text: 'Chocolate affects a dog\'s heart and nervous system; a few ounces are enough to kill a small dog.', answer: true),
    Question(text: 'In West Virginia, USA, if you accidentally hit an animal with your car, you are free to take it home to eat.', answer: true),
  ];
  int _questionNumber = 0;
  int _score = 0;


  Icon checkAnswer({bool button}){
    bool answer = _questions[_questionNumber].questionAnswer;

    if(_questionNumber < _questions.length){
      _questionNumber++;
    }

    if(answer == button){
      _score++;
      return rightAnswer();
    }else
      return wrongAndwer();
  }

  Icon rightAnswer(){
    return Icon(
      Icons.check,
      color: Colors.green,
    );
  }

  Icon wrongAndwer(){
    return Icon(
      Icons.close,
      color: Colors.red,
    );
  }

  String currentQuestionText(){
    return _questions[_questionNumber].questionText;
  }

  void restart(){
    _questionNumber = 0;
    _score = 0;
  }

  int getScore(){
    return _score;
  }

  int getNumberQuestion(){
    return _questions.length;
  }

  bool isEnd(){
    if(_questionNumber == _questions.length-1){
      return true;
    }else{
      return false;
    }
  }

}