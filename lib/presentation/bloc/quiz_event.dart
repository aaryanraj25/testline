abstract class QuizEvent {}

class LoadQuiz extends QuizEvent {}

class CompleteQuiz extends QuizEvent {}

class AnswerQuestion extends QuizEvent {
  final int questionId;
  final int optionId;

  AnswerQuestion({
    required this.questionId,
    required this.optionId,
  });
}