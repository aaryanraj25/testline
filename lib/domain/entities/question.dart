import 'option.dart';

class Question {
  final int id;
  final String description;
  final List<Option> options;
  final String detailedSolution;

  const Question({
    required this.id,
    required this.description,
    required this.options,
    required this.detailedSolution,
  });
}