import 'package:flutter/material.dart';
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/core/constants/app_text_styles.dart';
import 'package:testline/data/models/user_progress.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({Key? key, required this.achievement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: ListTile(
        leading: Image.asset(
          achievement.iconPath,
          width: 40,
          height: 40,
          color: achievement.isUnlocked ? null : Colors.grey,
        ),
        title: Text(
          achievement.title,
          style: AppTextStyles.body.copyWith(
            color: achievement.isUnlocked ? AppColors.text : Colors.grey,
          ),
        ),
        subtitle: Text(
          achievement.description,
          style: AppTextStyles.body.copyWith(
            color: achievement.isUnlocked ? AppColors.textSecondary : Colors.grey,
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          achievement.isUnlocked ? Icons.check_circle : Icons.lock,
          color: achievement.isUnlocked ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
