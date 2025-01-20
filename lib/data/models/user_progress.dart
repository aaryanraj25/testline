class UserProgress {
  final int totalPoints;
  final int currentStreak;
  final int highestStreak;
  final List<Achievement> achievements;
  final int level;
  final double levelProgress;

  UserProgress({
    required this.totalPoints,
    required this.currentStreak,
    required this.highestStreak,
    required this.achievements,
    required this.level,
    required this.levelProgress,
  });
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.isUnlocked,
  });
}