import 'package:bloc/bloc.dart';
import 'package:testline/core/usecases/usecases.dart';
import 'package:testline/domain/entities/quiz.dart';
import 'package:testline/domain/usecases/usecase.dart';
import 'package:testline/presentation/bloc/quiz_event.dart';
import 'package:testline/presentation/bloc/quiz_state.dart';
import 'package:testline/presentation/widgets/progress.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetQuiz getQuiz;
  final ProgressManager progressManager;

  QuizBloc({
    required this.getQuiz,
    required this.progressManager,
  }) : super(QuizInitial()) {
    on<LoadQuiz>(_onLoadQuiz);
    on<AnswerQuestion>(_onAnswerQuestion);
    on<CompleteQuiz>(_onCompleteQuiz);
  }

  Future<void> _onCompleteQuiz(CompleteQuiz event, Emitter<QuizState> emit) async {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      final score = _calculateScore(currentState.answers, currentState.quiz);
      await progressManager.updateProgress(score, currentState.quiz.questions.length);
    }
  }

  int _calculateScore(Map<int, int> answers, Quiz quiz) {
    int score = 0;
    answers.forEach((questionId, answerId) {
      final question = quiz.questions.firstWhere((q) => q.id == questionId);
      final option = question.options.firstWhere((o) => o.id == answerId);
      if (option.isCorrect) score++;
    });
    return score;
  }

  Future<void> _onLoadQuiz(LoadQuiz event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    try {
      final result = await getQuiz(NoParams());
      
      result.fold(
        (failure) => emit(QuizError(message: failure.message)),
        (quiz) => emit(QuizLoaded(quiz: quiz)),
      );
    } catch (e) {
      emit(QuizError(message: 'Failed to load quiz: ${e.toString()}'));
    }
  }

  Future<void> _onAnswerQuestion(AnswerQuestion event, Emitter<QuizState> emit) async {
    final currentState = state;
    if (currentState is QuizLoaded) {
      final newAnswers = Map<int, int>.from(currentState.answers);
      newAnswers[event.questionId] = event.optionId;
      
      emit(currentState.copyWith(answers: newAnswers));
    }
  }
}