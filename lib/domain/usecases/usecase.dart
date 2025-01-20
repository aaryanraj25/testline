import 'package:dartz/dartz.dart';
import 'package:testline/core/usecases/usecases.dart';
import '../../core/error/failures.dart';
import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class GetQuiz implements UseCase<Quiz, NoParams> {
  final QuizRepository repository;

  GetQuiz(this.repository);

  @override
  Future<Either<Failure, Quiz>> call(NoParams params) async {
    return await repository.getQuiz();
  }
}