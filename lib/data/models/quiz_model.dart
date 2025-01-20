import '../../domain/entities/quiz.dart';
import 'question_model.dart';

class QuizModel extends Quiz {
  const QuizModel({
    required int id,
    required String title,
    required String description,
    required List<QuestionModel> questions,
    required DateTime endsAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          questions: questions,
          endsAt: endsAt,
        );

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      questions: (json['questions'] as List)
          .map((question) => QuestionModel.fromJson(question))
          .toList(),
      endsAt: DateTime.parse(json['ends_at']),
    );
  }
}