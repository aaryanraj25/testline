import 'package:flutter/material.dart';
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/core/constants/app_text_styles.dart';
import 'package:testline/domain/entities/quiz.dart';
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

class _ResultsPageState extends State<ResultsPage> {
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

  void toggleQuestion(int questionId) {
    setState(() {
      if (expandedQuestions.contains(questionId)) {
        expandedQuestions.remove(questionId);
      } else {
        expandedQuestions.add(questionId);
      }
    });
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
          // Score Card
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  score >= (widget.quiz.questions.length * 0.7)
                      ? Icons.emoji_events
                      : Icons.school,
                  size: 48,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  '$score/${widget.quiz.questions.length}',
                  style: AppTextStyles.heading,
                ),
                const SizedBox(height: 8),
                Text(
                  '${(score / widget.quiz.questions.length * 100).round()}%',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Questions Review
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
                      // Question Header
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

                      // Expanded Content
                      if (expandedQuestions.contains(question.id))
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const SizedBox(height: 8),
                              Text(
                                'Your Answer:',
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
                                  userAnswer.description,
                                  style: AppTextStyles.body,
                                ),
                              ),
                              if (!isCorrect) ...[
                                const SizedBox(height: 16),
                                Text(
                                  'Correct Answer:',
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: Text(
                                    correctAnswer.description,
                                    style: AppTextStyles.body,
                                  ),
                                ),
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

          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Try Again',
                    onPressed: () {
                      // Clear the quiz state and navigate back to quiz page
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/quiz',
                        (route) => route.isFirst,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}