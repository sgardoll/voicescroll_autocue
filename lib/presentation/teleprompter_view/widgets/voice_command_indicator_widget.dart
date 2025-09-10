import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceCommandIndicatorWidget extends StatelessWidget {
  final bool isListening;
  final String? lastCommand;
  final bool isVisible;

  const VoiceCommandIndicatorWidget({
    Key? key,
    required this.isListening,
    this.lastCommand,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.secondary.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isListening ? AppTheme.accent : AppTheme.border,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowDark,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMicrophoneIcon(),
            if (lastCommand != null) ...[
              SizedBox(width: 2.w),
              _buildCommandText(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMicrophoneIcon() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: CustomIconWidget(
        iconName: isListening ? 'mic' : 'mic_off',
        color: isListening ? AppTheme.accent : AppTheme.textSecondary,
        size: 20,
      ),
    );
  }

  Widget _buildCommandText() {
    return Container(
      constraints: BoxConstraints(maxWidth: 30.w),
      child: Text(
        lastCommand ?? '',
        style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          color: AppTheme.textSecondary,
          fontSize: 10.sp,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
