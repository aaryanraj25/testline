import 'package:flutter/material.dart';
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/core/constants/app_text_styles.dart';
import 'package:testline/domain/entities/option.dart';

class OptionButton extends StatelessWidget {
  final Option option;
  final VoidCallback onTap;

  const OptionButton({
    Key? key,
    required this.option,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            option.description,
            style: AppTextStyles.body,
          ),
        ),
      ),
    );
  }
}