import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/core/constants/app_text_styles.dart';
import 'package:testline/core/constants/assets.dart';
import 'package:testline/domain/entities/quiz.dart';
import 'package:testline/presentation/bloc/quiz_bloc.dart';
import 'package:testline/presentation/bloc/quiz_event.dart';
import 'package:testline/presentation/widgets/custom_buttons.dart';

class ResultsPage extends StatefulWidget {
  final Map<int, int> answers;
  final Quiz quiz;

  const ResultsPage({
    Key? key,
    required this.answers,
    required this.quiz,
  }) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;
  late Animation<double> _scaleAnimation;
  Set<int> expandedQuestions = {};

  int get score {
    int correct = 0;
    widget.answers.forEach((questionId, answerId) {
      final question = widget.quiz.questions.firstWhere((q) => q.id == questionId);
      final option = question.options.firstWhere((o) => o.id == answerId);
      if (option.isCorrect) correct++;
    });
    return correct;
  }

  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(CompleteQuiz());
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _scoreAnimation = Tween<double>(
      begin: 0,
      end: score.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleQuestion(int questionId) {
    setState(() {
      if (expandedQuestions.contains(questionId)) {
        expandedQuestions.remove(questionId);
      } else {
        expandedQuestions.add(questionId);
      }
    });
  }

  void _retryQuiz(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/quiz',
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Quiz Results', style: AppTextStyles.heading),
        elevation: 0,
      ),
      body: Column(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        score >= (widget.quiz.questions.length * 0.7)
                            ? Assets.trophy
                            : Assets.brain,
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_scoreAnimation.value.toInt()}/${widget.quiz.questions.length}',
                        style: AppTextStyles.heading.copyWith(fontSize: 48),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(score / widget.quiz.questions.length * 100).round()}%',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.quiz.questions.length,
              itemBuilder: (context, index) {
                final question = widget.quiz.questions[index];
                final userAnswerId = widget.answers[question.id];
                final userAnswer = question.options
                    .firstWhere((option) => option.id == userAnswerId);
                final correctAnswer =
                    question.options.firstWhere((option) => option.isCorrect);
                final isCorrect = userAnswer.isCorrect;

                return Card(
                  color: AppColors.surface,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => toggleQuestion(question.id),
                        leading: Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          question.description,
                          style: AppTextStyles.body,
                        ),
                        trailing: Icon(
                          expandedQuestions.contains(question.id)
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                      ),
                      if (expandedQuestions.contains(question.id))
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const SizedBox(height: 8),
                              _buildAnswerSection('Your Answer:', userAnswer.description, isCorrect),
                              if (!isCorrect) ...[
                                const SizedBox(height: 16),
                                _buildAnswerSection('Correct Answer:', correctAnswer.description, true),
                              ],
                              const SizedBox(height: 16),
                              Text(
                                'Explanation:',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.detailedSolution,
                                style: AppTextStyles.body,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Try Again',
                    onPressed: () => _retryQuiz(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSection(String label, String answer, bool isCorrect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCorrect
                ? Colors.green.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCorrect ? Colors.green : Colors.red,
            ),
          ),
          child: Text(
            answer,
            style: AppTextStyles.body,
          ),
        ),
      ],
    );
  }
}