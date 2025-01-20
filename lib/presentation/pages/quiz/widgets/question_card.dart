import 'package:flutter/material.dart';
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/core/constants/app_text_styles.dart';
import 'package:testline/domain/entities/question.dart';
import 'package:testline/domain/entities/option.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final Function(int) onAnswer;
  final VoidCallback onNext;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.onAnswer,
    required this.onNext,
  }) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with SingleTickerProviderStateMixin {
  Option? selectedOption;
  bool showExplanation = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleOptionSelection(Option option) {
    if (selectedOption != null) return; // Prevent multiple selections

    setState(() {
      selectedOption = option;
      showExplanation = true;
    });
    widget.onAnswer(option.id);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.question.description,
                  style: AppTextStyles.body.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 24),
                ...widget.question.options.map((option) {
                  final bool isSelected = selectedOption == option;
                  final bool showResult = selectedOption != null;
                  final bool isCorrect = option.isCorrect;

                  Color getOptionColor() {
                    if (!showResult) return AppColors.surface;
                    if (isSelected && isCorrect) return Colors.green.withOpacity(0.2);
                    if (isSelected && !isCorrect) return Colors.red.withOpacity(0.2);
                    if (!isSelected && isCorrect) return Colors.green.withOpacity(0.2);
                    return AppColors.surface;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: selectedOption == null
                              ? () => _handleOptionSelection(option)
                              : null,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: getOptionColor(),
                              border: Border.all(
                                color: showResult && (isSelected || isCorrect)
                                    ? isCorrect
                                        ? Colors.green
                                        : Colors.red
                                    : AppColors.primary.withOpacity(0.3),
                                width: showResult && (isSelected || isCorrect) ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option.description,
                                    style: AppTextStyles.body,
                                  ),
                                ),
                                if (showResult && (isSelected || isCorrect))
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: isCorrect ? Colors.green : Colors.red,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // Explanation Section
          if (showExplanation)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedOption?.isCorrect ?? false
                              ? Colors.green
                              : Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                selectedOption?.isCorrect ?? false
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: selectedOption?.isCorrect ?? false
                                    ? Colors.green
                                    : Colors.red,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                selectedOption?.isCorrect ?? false
                                    ? 'Correct!'
                                    : 'Incorrect',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Explanation:',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.question.detailedSolution,
                            style: AppTextStyles.body,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: widget.onNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Next Question',
                                style: AppTextStyles.button,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}