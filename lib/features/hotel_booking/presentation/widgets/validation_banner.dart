import 'package:flutter/material.dart';
import '../../../../core/failure/validation_failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ValidationBanner extends StatelessWidget {
  final ValidationFailure? failure;

  const ValidationBanner({
    super.key,
    required this.failure,
  });

  @override
  Widget build(BuildContext context) {
    if (failure == null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.successBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.successBorder),
        ),
        child: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: AppColors.successText, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Dates and room valid. Ready to reserve!',
                style: TextStyle(
                  color: AppColors.successText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.errorText, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              failure!.message,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.errorText,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
