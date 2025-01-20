import '../../domain/entities/question.dart';
import 'option_model.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required int id,
    required String description,
    required List<OptionModel> options,
    required String detailedSolution,
  }) : super(
          id: id,
          description: description,
          options: options,
          detailedSolution: detailedSolution,
        );

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      description: json['description'],
      options: (json['options'] as List)
          .map((option) => OptionModel.fromJson(option))
          .toList(),
      detailedSolution: json['detailed_solution'],
    );
  }
}