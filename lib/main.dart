import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/data/datasources/quiz_remote_datasource.dart';
import 'package:testline/data/repositories/quiz_repository_impl.dart';
import 'package:testline/domain/usecases/usecase.dart';
import 'package:testline/presentation/bloc/quiz_bloc.dart';
import 'package:testline/presentation/pages/dashboard/dashnoard_page.dart';
import 'package:testline/presentation/pages/quiz/quiz_page.dart';
import 'package:testline/presentation/widgets/progress.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = http.Client();
  final remoteDataSource = QuizRemoteDataSourceImpl(client: httpClient);
  final repository = QuizRepositoryImpl(remoteDataSource: remoteDataSource);
  final getQuiz = GetQuiz(repository);
  final sharedPreferences = await SharedPreferences.getInstance();
  final progressManager = ProgressManager(sharedPreferences);

  runApp(QuizApp(
    getQuiz: getQuiz,
    progressManager: progressManager,
  ));
}

class QuizApp extends StatelessWidget {
  final GetQuiz getQuiz;
  final ProgressManager progressManager;

  const QuizApp({
    Key? key,
    required this.getQuiz,
    required this.progressManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuizBloc>(
          create: (context) => QuizBloc(
            getQuiz: getQuiz,
            progressManager: progressManager,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Quiz App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => DashboardPage(progressManager: progressManager),
          '/quiz': (context) => const QuizPage(),
        },
      ),
    );
  }
}
