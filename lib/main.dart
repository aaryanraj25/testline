import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/data/datasources/quiz_remote_datasource.dart';
import 'package:testline/data/repositories/quiz_repository_impl.dart';
import 'package:testline/domain/usecases/usecase.dart';
import 'package:testline/presentation/bloc/quiz_bloc.dart';
import 'package:testline/presentation/pages/dashboard/dashnoard_page.dart';
import 'package:testline/presentation/pages/quiz/quiz_page.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create dependencies
    final httpClient = http.Client();
    final remoteDataSource = QuizRemoteDataSourceImpl(client: httpClient);
    final repository = QuizRepositoryImpl(remoteDataSource: remoteDataSource);
    final getQuiz = GetQuiz(repository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<QuizBloc>(
          create: (context) => QuizBloc(getQuiz: getQuiz),
        ),
      ],
      child: MaterialApp(
        title: 'Quiz App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
        ),
        routes: {
          '/': (context) => DashboardPage(),
          '/quiz': (context) => const QuizPage(),
        },
      ),
    );
  }
}