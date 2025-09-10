import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TeleprompterTextWidget extends StatelessWidget {
  final String text;
  final int currentWordIndex;
  final double fontSize;
  final ScrollController scrollController;
  final VoidCallback onTap;

  const TeleprompterTextWidget({
    Key? key,
    required this.text,
    required this.currentWordIndex,
    required this.fontSize,
    required this.scrollController,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.surface,
        child: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 8.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextContent(words),
              SizedBox(height: 20.h), // Extra space for scrolling
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(List<String> words) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          color: AppTheme.textPrimary,
          fontFamily: 'Roboto',
          height: 1.6,
          letterSpacing: 0.5,
        ),
        children: _buildTextSpans(words),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(List<String> words) {
    List<TextSpan> spans = [];

    for (int i = 0; i < words.length; i++) {
      final isCurrentWord = i == currentWordIndex;
      final isUpcomingWord = i > currentWordIndex && i <= currentWordIndex + 5;

      Color textColor = AppTheme.textPrimary;
      Color? backgroundColor;
      FontWeight fontWeight = FontWeight.w400;

      if (isCurrentWord) {
        backgroundColor = AppTheme.accent.withValues(alpha: 0.3);
        fontWeight = FontWeight.w600;
      } else if (isUpcomingWord) {
        textColor = AppTheme.textPrimary.withValues(alpha: 0.9);
        fontWeight = FontWeight.w500;
      } else if (i < currentWordIndex) {
        textColor = AppTheme.textSecondary.withValues(alpha: 0.6);
      }

      spans.add(
        TextSpan(
          text: '${words[i]} ',
          style: TextStyle(
            color: textColor,
            backgroundColor: backgroundColor,
            fontWeight: fontWeight,
          ),
        ),
      );
    }

    return spans;
  }
}
