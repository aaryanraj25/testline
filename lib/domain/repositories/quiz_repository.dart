import 'package:dartz/dartz.dart';
import '../entities/quiz.dart';
import '../../core/error/failures.dart';

abstract class QuizRepository {
  Future<Either<Failure, Quiz>> getQuiz();
}