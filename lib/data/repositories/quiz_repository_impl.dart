import 'package:dartz/dartz.dart';
import 'package:testline/domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_remote_datasource.dart';
import '../../core/error/failures.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  QuizRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Quiz>> getQuiz() async {
    try {
      final quiz = await remoteDataSource.getQuiz();
      return Right(quiz);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch quiz'));
    }
  }
}