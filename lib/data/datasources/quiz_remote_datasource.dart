import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_model.dart';

abstract class QuizRemoteDataSource {
  Future<QuizModel> getQuiz();
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final http.Client client;

  QuizRemoteDataSourceImpl({required this.client});

  @override
  Future<QuizModel> getQuiz() async {
    final response = await client.get(
      Uri.parse('https://api.jsonserve.com/Uw5CrX'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return QuizModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server Error']);
}