import 'package:bloc/bloc.dart';
import 'package:testline/core/usecases/usecases.dart';
import 'package:testline/domain/usecases/usecase.dart';
import 'package:testline/presentation/bloc/quiz_event.dart';
import 'package:testline/presentation/bloc/quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetQuiz getQuiz;

  QuizBloc({required this.getQuiz}) : super(QuizInitial()) {
    on<LoadQuiz>(_onLoadQuiz);
    on<AnswerQuestion>(_onAnswerQuestion);
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