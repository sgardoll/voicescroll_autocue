import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionModalWidget extends StatelessWidget {
  final VoidCallback onAllowPressed;
  final VoidCallback onDenyPressed;

  const PermissionModalWidget({
    Key? key,
    required this.onAllowPressed,
    required this.onDenyPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accent.withValues(alpha: 0.1),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'mic',
                  color: AppTheme.accent,
                  size: 8.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Microphone Permission Required',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 4.5.w,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'VoiceScroll Autocue needs access to your microphone to recognize your voice and automatically scroll through your scripts.',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 3.5.w,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDenyPressed,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      side: BorderSide(color: AppTheme.border),
                    ),
                    child: Text(
                      'Not Now',
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.textSecondary,
                        fontSize: 3.5.w,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAllowPressed,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      backgroundColor: AppTheme.accent,
                    ),
                    child: Text(
                      'Allow',
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontSize: 3.5.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
