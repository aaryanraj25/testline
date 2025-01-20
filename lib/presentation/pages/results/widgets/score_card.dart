import 'package:flutter/material.dart';
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/core/constants/app_text_styles.dart';

class ScoreCard extends StatelessWidget {
  final int score;
  final int total;

  const ScoreCard({
    Key? key,
    required this.score,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (score / total * 100).round();
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            percentage >= 70 ? Icons.emoji_events : Icons.school,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            '$score / $total',
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 8),
          Text(
            '$percentage%',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getFeedbackMessage(percentage),
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getFeedbackMessage(int percentage) {
    if (percentage >= 90) return 'Excellent work!';
    if (percentage >= 70) return 'Good job!';
    if (percentage >= 50) return 'Keep practicing!';
    return 'Don\'t give up!';
  }
}