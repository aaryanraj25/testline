import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:testline/data/models/user_progress.dart';

class ProgressManager {
  static const String _keyTotalPoints = 'total_points';
  static const String _keyCurrentStreak = 'current_streak';
  static const String _keyHighestStreak = 'highest_streak';
  static const String _keyLevel = 'level';
  static const String _keyLevelProgress = 'level_progress';
  static const String _keyLastQuizDate = 'last_quiz_date';
  static const String _keyAchievements = 'achievements';

  final SharedPreferences _prefs;

  ProgressManager(this._prefs);

  Future<void> updateProgress(int score, int totalQuestions) async {
    final DateTime now = DateTime.now();
    final String? lastQuizDateStr = _prefs.getString(_keyLastQuizDate);
    final DateTime? lastQuizDate = lastQuizDateStr != null 
        ? DateTime.parse(lastQuizDateStr)
        : null;

    final int pointsEarned = _calculatePoints(score, totalQuestions);
    
    final int currentTotal = _prefs.getInt(_keyTotalPoints) ?? 0;
    final int newTotal = currentTotal + pointsEarned;
    await _prefs.setInt(_keyTotalPoints, newTotal);

    if (lastQuizDate != null) {
      final bool isConsecutiveDay = now.difference(lastQuizDate).inDays == 1;
      if (isConsecutiveDay) {
        final int currentStreak = _prefs.getInt(_keyCurrentStreak) ?? 0;
        final int newStreak = currentStreak + 1;
        await _prefs.setInt(_keyCurrentStreak, newStreak);

        final int highestStreak = _prefs.getInt(_keyHighestStreak) ?? 0;
        if (newStreak > highestStreak) {
          await _prefs.setInt(_keyHighestStreak, newStreak);
        }
      } else if (now.difference(lastQuizDate).inDays > 1) {
        await _prefs.setInt(_keyCurrentStreak, 1);
      }
    } else {
      await _prefs.setInt(_keyCurrentStreak, 1);
      await _prefs.setInt(_keyHighestStreak, 1);
    }

    await _prefs.setString(_keyLastQuizDate, now.toIso8601String());

    await _updateLevel(newTotal);
    
    await _checkAndUpdateAchievements(score, totalQuestions);
  }

  int _calculatePoints(int score, int totalQuestions) {
    final double percentage = score / totalQuestions;
    final int basePoints = (score * 100).round();
    

    if (percentage >= 0.9) return (basePoints * 1.5).round();
    if (percentage >= 0.8) return (basePoints * 1.2).round();
    return basePoints;
  }

  Future<void> _updateLevel(int totalPoints) async {
    int level = 1;
    int pointsRequired = 1000;
    int remainingPoints = totalPoints;

    while (remainingPoints >= pointsRequired) {
      remainingPoints -= pointsRequired;
      level++;
      pointsRequired = 1000 * level;
    }

    await _prefs.setInt(_keyLevel, level);
    await _prefs.setDouble(_keyLevelProgress, remainingPoints / pointsRequired);
  }

  Future<void> _checkAndUpdateAchievements(int score, int totalQuestions) async {
    final List<Achievement> currentAchievements = await getAchievements();
    final List<Achievement> newAchievements = [];

    if (score == totalQuestions && !_hasAchievement(currentAchievements, 'perfect_score')) {
      newAchievements.add(Achievement(
        id: 'perfect_score',
        title: 'Perfect Score',
        description: 'Score 100% on a quiz',
        iconPath: 'assets/images/trophy.png',
        isUnlocked: true,
      ));
    }

    final int currentStreak = _prefs.getInt(_keyCurrentStreak) ?? 0;
    if (currentStreak >= 7 && !_hasAchievement(currentAchievements, 'weekly_streak')) {
      newAchievements.add(Achievement(
        id: 'weekly_streak',
        title: '7 Day Streak',
        description: 'Complete quizzes for 7 days in a row',
        iconPath: 'assets/images/fire.png',
        isUnlocked: true,
      ));
    }

    if (newAchievements.isNotEmpty) {
      final List<Achievement> updatedAchievements = [
        ...currentAchievements,
        ...newAchievements,
      ];
      await _saveAchievements(updatedAchievements);
    }
  }

  bool _hasAchievement(List<Achievement> achievements, String id) {
    return achievements.any((achievement) => achievement.id == id && achievement.isUnlocked);
  }

  Future<UserProgress> getUserProgress() async {
    return UserProgress(
      totalPoints: _prefs.getInt(_keyTotalPoints) ?? 0,
      currentStreak: _prefs.getInt(_keyCurrentStreak) ?? 0,
      highestStreak: _prefs.getInt(_keyHighestStreak) ?? 0,
      achievements: await getAchievements(),
      level: _prefs.getInt(_keyLevel) ?? 1,
      levelProgress: _prefs.getDouble(_keyLevelProgress) ?? 0.0,
    );
  }

  Future<List<Achievement>> getAchievements() async {
    final String achievementsJson = _prefs.getString(_keyAchievements) ?? '[]';
    final List<dynamic> achievementsList = json.decode(achievementsJson);
    return achievementsList.map((json) => Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconPath: json['iconPath'],
      isUnlocked: json['isUnlocked'],
    )).toList();
  }

  Future<void> _saveAchievements(List<Achievement> achievements) async {
    final List<Map<String, dynamic>> achievementsList = achievements
        .map((achievement) => {
              'id': achievement.id,
              'title': achievement.title,
              'description': achievement.description,
              'iconPath': achievement.iconPath,
              'isUnlocked': achievement.isUnlocked,
            })
        .toList();
    await _prefs.setString(_keyAchievements, json.encode(achievementsList));
  }
}