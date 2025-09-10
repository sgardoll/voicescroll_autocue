import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalibrationControlsWidget extends StatelessWidget {
  final bool isListening;
  final bool isPaused;
  final VoidCallback onStartStop;
  final VoidCallback onPauseResume;
  final VoidCallback onSkip;
  final VoidCallback onRestart;
  final bool canSkip;

  const CalibrationControlsWidget({
    Key? key,
    required this.isListening,
    required this.isPaused,
    required this.onStartStop,
    required this.onPauseResume,
    required this.onSkip,
    required this.onRestart,
    this.canSkip = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          // Primary controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Pause/Resume button
              _buildControlButton(
                icon: isPaused ? 'play_arrow' : 'pause',
                label: isPaused ? 'Resume' : 'Pause',
                onPressed: isListening ? onPauseResume : null,
                color: AppTheme.accent,
                isSecondary: true,
              ),

              // Start/Stop button
              _buildControlButton(
                icon: isListening ? 'stop' : 'mic',
                label: isListening ? 'Stop' : 'Start',
                onPressed: onStartStop,
                color: isListening ? AppTheme.error : AppTheme.success,
                isSecondary: false,
              ),

              // Skip button
              _buildControlButton(
                icon: 'skip_next',
                label: 'Skip',
                onPressed: canSkip ? onSkip : null,
                color: AppTheme.warning,
                isSecondary: true,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Secondary controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: onRestart,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: AppTheme.textSecondary,
                  size: 4.w,
                ),
                label: Text(
                  'Restart Calibration',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.textSecondary,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Status text
          if (isListening && !isPaused) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.success,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  'Listening for your voice...',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ] else if (isPaused) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'pause_circle_outline',
                  color: AppTheme.warning,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Calibration paused',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
    required bool isSecondary,
  }) {
    return Column(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          child: isSecondary
              ? OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(
                      color: onPressed != null ? color : AppTheme.border,
                      width: 2,
                    ),
                    shape: CircleBorder(),
                    padding: EdgeInsets.zero,
                  ),
                  child: CustomIconWidget(
                    iconName: icon,
                    color: onPressed != null ? color : AppTheme.textSecondary,
                    size: 6.w,
                  ),
                )
              : ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        onPressed != null ? color : AppTheme.border,
                    foregroundColor: AppTheme.textPrimary,
                    shape: CircleBorder(),
                    padding: EdgeInsets.zero,
                    elevation: onPressed != null ? 4 : 0,
                  ),
                  child: CustomIconWidget(
                    iconName: icon,
                    color: AppTheme.textPrimary,
                    size: 6.w,
                  ),
                ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
            color: onPressed != null
                ? AppTheme.textPrimary
                : AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
