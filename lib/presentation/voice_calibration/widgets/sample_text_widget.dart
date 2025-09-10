import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SampleTextWidget extends StatelessWidget {
  final String fullText;
  final List<String> recognizedWords;
  final int currentWordIndex;

  const SampleTextWidget({
    Key? key,
    required this.fullText,
    required this.recognizedWords,
    required this.currentWordIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = fullText.split(' ');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practice Text',
            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),

          // Text with highlighting
          RichText(
            text: TextSpan(
              children: words.asMap().entries.map((entry) {
                final index = entry.key;
                final word = entry.value;

                Color textColor;
                FontWeight fontWeight;
                Color? backgroundColor;

                if (index < recognizedWords.length) {
                  // Already recognized - green
                  textColor = AppTheme.success;
                  fontWeight = FontWeight.w500;
                } else if (index == currentWordIndex) {
                  // Currently expected - highlighted
                  textColor = AppTheme.textPrimary;
                  fontWeight = FontWeight.w600;
                  backgroundColor = AppTheme.accent.withValues(alpha: 0.3);
                } else {
                  // Not yet reached - normal
                  textColor = AppTheme.textSecondary;
                  fontWeight = FontWeight.w400;
                }

                return TextSpan(
                  text: index == words.length - 1 ? word : '$word ',
                  style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontWeight: fontWeight,
                    backgroundColor: backgroundColor,
                    height: 1.6,
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 3.h),

          // Progress indicator
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: recognizedWords.length / words.length,
                  backgroundColor: AppTheme.border,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.success),
                  minHeight: 0.5.h,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                '${recognizedWords.length}/${words.length}',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
