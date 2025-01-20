import '../../domain/entities/option.dart';

class OptionModel extends Option {
  const OptionModel({
    required int id,
    required String description,
    required bool isCorrect,
  }) : super(
          id: id,
          description: description,
          isCorrect: isCorrect,
        );

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'],
      description: json['description'],
      isCorrect: json['is_correct'] ?? false,
    );
  }
}