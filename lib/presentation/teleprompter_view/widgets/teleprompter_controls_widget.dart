import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TeleprompterControlsWidget extends StatelessWidget {
  final bool isPlaying;
  final double scrollSpeed;
  final VoidCallback onPlayPause;
  final VoidCallback onSpeedDecrease;
  final VoidCallback onSpeedIncrease;
  final VoidCallback onExit;
  final bool isVisible;

  const TeleprompterControlsWidget({
    Key? key,
    required this.isPlaying,
    required this.scrollSpeed,
    required this.onPlayPause,
    required this.onSpeedDecrease,
    required this.onSpeedIncrease,
    required this.onExit,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: double.infinity,
        height: 12.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppTheme.surface.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: 'close',
                onTap: onExit,
                color: AppTheme.error,
              ),
              _buildControlButton(
                icon: 'remove',
                onTap: onSpeedDecrease,
                color: AppTheme.textSecondary,
              ),
              _buildPlayPauseButton(),
              _buildControlButton(
                icon: 'add',
                onTap: onSpeedIncrease,
                color: AppTheme.textSecondary,
              ),
              _buildSpeedIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: AppTheme.secondary.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: onPlayPause,
      child: Container(
        width: 16.w,
        height: 8.h,
        decoration: BoxDecoration(
          color: AppTheme.accent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accent.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: isPlaying ? 'pause' : 'play_arrow',
            color: AppTheme.textPrimary,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedIndicator() {
    return Container(
      width: 16.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: AppTheme.secondary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          '${scrollSpeed.toStringAsFixed(1)}x',
          style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
