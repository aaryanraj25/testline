import 'package:testline/domain/entities/quiz.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final Quiz quiz;
  final Map<int, int> answers; // questionId -> optionId

  QuizLoaded({
    required this.quiz,
    this.answers = const {},
  });

  QuizLoaded copyWith({
    Quiz? quiz,
    Map<int, int>? answers,
  }) {
    return QuizLoaded(
      quiz: quiz ?? this.quiz,
      answers: answers ?? this.answers,
    );
  }
}

class QuizError extends QuizState {
  final String message;

  QuizError({required this.message});
}