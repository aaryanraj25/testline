import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/core/constants/app_text_styles.dart';
import 'package:testline/presentation/bloc/quiz_bloc.dart';
import 'package:testline/presentation/bloc/quiz_event.dart';
import 'package:testline/presentation/widgets/custom_buttons.dart';

class QuizErrorWidget extends StatelessWidget {
  final String message;

  const QuizErrorWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Try Again',
            onPressed: () {
              context.read<QuizBloc>().add(LoadQuiz());
            },
          ),
        ],
      ),
    );
  }
}