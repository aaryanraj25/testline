# Testline App

A modern, interactive Flutter quiz application with animated results and a gamified learning experience.

## Features

- Interactive quiz interface with multiple-choice questions
- Animated score reveal and results page
- Detailed feedback for each question
- Progress tracking and achievements
- Daily challenges with bonus points
- Responsive design with smooth animations

## Submission
1. Video Link: https://drive.google.com/file/d/1wfJ6gPgIdPEXC2ylu6jStf34bYIxbZfp/view?usp=drive_link

2. Apk Link: https://drive.google.com/file/d1gjKOnuqcjhZo0o-kj4zadK-tXX1wCzOO/view?usp=sharing

3. Screenshot Link: https://drive.google.com/drive/folders/1duKbwmuASUCo575qD3Q0XByuWwhEjPcO?usp=drive_link

## Prerequisites

- Flutter SDK (2.5.0 or higher)
- Dart SDK (2.14.0 or higher)
- Android Studio / VS Code with Flutter extensions

## Installation

1. Clone the repository:
```bash
git clone https://github.com/aaryanraj25/quiz-app.git
```

2. Navigate to the project directory:
```bash
cd testline
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Configuration

1. Update the `assets` folder with your images:
```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/images/trophy.png
    - assets/images/brain.png
```

2. Configure app colors in `lib/core/constants/app_colors.dart`:
```dart
class AppColors {
  static const Color primary = Color(0xFF...);
  static const Color background = Color(0xFF...);
  // ...
}
```

## Usage

1. Create quiz data:
```dart
final quiz = Quiz(
  questions: [
    Question(
      id: 1,
      description: "What is...",
      options: [...],
      detailedSolution: "...",
    ),
    // ...
  ],
);
```

2. Navigate to the results page:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ResultsPage(
      answers: userAnswers,
      quiz: quiz,
    ),
  ),
);
```

