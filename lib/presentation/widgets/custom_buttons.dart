import 'package:flutter/material.dart';
import 'package:testline/core/constants/app_colors.dart';
import 'package:testline/core/constants/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; 
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed, 
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : 
              onPressed == null ? AppColors.primary.withOpacity(0.5) : AppColors.primary,
          foregroundColor: AppColors.text,
          side: isOutlined ? BorderSide(color: 
              onPressed == null ? AppColors.primary.withOpacity(0.5) : AppColors.primary) : null,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button.copyWith(
            color: onPressed == null ? AppColors.text.withOpacity(0.5) : AppColors.text,
          ),
        ),
      ),
    );
  }
}
