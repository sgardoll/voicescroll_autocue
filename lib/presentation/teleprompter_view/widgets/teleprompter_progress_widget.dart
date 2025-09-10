import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TeleprompterProgressWidget extends StatelessWidget {
  final double progress;
  final bool isVisible;

  const TeleprompterProgressWidget({
    Key? key,
    required this.progress,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: double.infinity,
        height: 1.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.transparent,
              AppTheme.surface.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.border.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
            minHeight: 0.3.h,
          ),
        ),
      ),
    );
  }
}
