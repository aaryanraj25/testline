import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/core/constants/app_text_styles.dart';
import 'package:testline/domain/entities/quiz.dart';
import 'package:testline/presentation/bloc/quiz_bloc.dart';
import 'package:testline/presentation/bloc/quiz_event.dart';
import 'package:testline/presentation/bloc/quiz_state.dart';
import 'package:testline/presentation/pages/quiz/quiz_error_widget.dart';
import 'package:testline/presentation/pages/quiz/widgets/question_card.dart';
import 'package:testline/presentation/pages/results/results_page.dart';
import 'package:testline/presentation/widgets/loading_widget.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizBloc>().add(LoadQuiz());
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Quiz', style: AppTextStyles.heading),
        elevation: 0,
      ),
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is QuizLoading) {
            return LoadingWidget();
          }

          if (state is QuizLoaded) {
            return QuizContent(quiz: state.quiz);
          }

          if (state is QuizError) {
            return QuizErrorWidget(message: state.message);
          }

          return LoadingWidget();
        },
      ),
    );
  }
}

class QuizContent extends StatefulWidget {
  final Quiz quiz;

  const QuizContent({Key? key, required this.quiz}) : super(key: key);

  @override
  State<QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends State<QuizContent> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleAnswer(int answerId) {
    context.read<QuizBloc>().add(
          AnswerQuestion(
            questionId: widget.quiz.questions[_currentIndex].id,
            optionId: answerId,
          ),
        );
  }

  void _handleNext() {
    if (_currentIndex < widget.quiz.questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final state = context.read<QuizBloc>().state;
      if (state is QuizLoaded) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              answers: state.answers,
              quiz: widget.quiz,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background,
                AppColors.surface,
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (_currentIndex + 1) / widget.quiz.questions.length,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Question ${_currentIndex + 1}/${widget.quiz.questions.length}',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  widget.quiz.title,
                  style: AppTextStyles.heading,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.quiz.questions.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return QuestionCard(
                        question: widget.quiz.questions[index],
                        onAnswer: _handleAnswer,
                        onNext: _handleNext,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}