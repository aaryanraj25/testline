import 'package:flutter/material.dart';
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/core/constants/app_text_styles.dart';
import 'package:testline/core/constants/assets.dart';
import 'package:testline/data/models/user_progress.dart';
import 'package:testline/presentation/widgets/custom_buttons.dart';
import 'package:testline/presentation/widgets/loading_widget.dart';
import 'package:testline/presentation/widgets/progress.dart';

class DashboardPage extends StatelessWidget {
  final ProgressManager progressManager;

  const DashboardPage({Key? key, required this.progressManager})
      : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProgress>(
      future: progressManager.getUserProgress(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }

        final progress = snapshot.data!;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(progress),
                    const SizedBox(height: 24),
                    _buildProgressSection(progress),
                    const SizedBox(height: 24),
                    _buildDailyChallenge(context),
                    const SizedBox(height: 24),
                    _buildAchievements(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

 Widget _buildHeader(UserProgress progress) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primary,
          child: Text(
            '${progress.level}',
            style: AppTextStyles.heading,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level ${progress.level}',
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress.levelProgress,
                backgroundColor: AppColors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

  Widget _buildProgressSection(UserProgress progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.stars,
                value: '${progress.totalPoints}',
                label: 'Total Points',
              ),
              _buildStatItem(
                icon: Icons.local_fire_department,
                value: '${progress.currentStreak} / ${progress.highestStreak}',
                label: 'Day Streak',
              ),
              _buildStatItem(
                icon: Icons.emoji_events,
                value: '${progress.achievements}',
                label: 'Achievements',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 32),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.heading.copyWith(fontSize: 20)),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyChallenge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                Assets.brain,
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Daily Challenge',
                  style: AppTextStyles.heading.copyWith(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '2X Points',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Complete today\'s quiz to maintain your streak!',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Start Challenge',
            onPressed: () => Navigator.pushNamed(context, '/quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Achievements',
          style: AppTextStyles.heading.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildAchievementItem(
                icon: Assets.trophy,
                title: 'Perfect Score',
                isUnlocked: true,
              ),
              _buildAchievementItem(
                icon: Assets.brain,
                title: '7 Day Streak',
                isUnlocked: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem({
    required String icon,
    required String title,
    required bool isUnlocked,
  }) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? AppColors.primary : Colors.grey,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: 40,
            height: 40,
            color: isUnlocked ? null : Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              fontSize: 12,
              color: isUnlocked ? AppColors.text : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Leaderboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Achievements',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
