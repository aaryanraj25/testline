import 'question.dart';

class Quiz {
  final int id;
  final String title;
  final String description;
  final List<Question> questions;
  final DateTime endsAt;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.endsAt,
  });
}