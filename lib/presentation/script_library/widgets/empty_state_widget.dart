import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onImportTap;

  const EmptyStateWidget({
    super.key,
    required this.onImportTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.border,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'description',
                    color: AppTheme.textSecondary,
                    size: 60,
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    width: 20.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppTheme.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 15.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppTheme.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 18.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppTheme.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              'No Scripts Yet',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              'Import your first script to get started with VoiceScroll Autocue. You can scan documents, import files, or create new scripts.',
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Call to Action Button
            ElevatedButton.icon(
              onPressed: onImportTap,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.textPrimary,
                size: 20,
              ),
              label: Text(
                'Import Your First Script',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.textPrimary,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),

            SizedBox(height: 2.h),

            // Secondary Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Navigate to help or tutorial
                  },
                  icon: CustomIconWidget(
                    iconName: 'help_outline',
                    color: AppTheme.textSecondary,
                    size: 16,
                  ),
                  label: Text(
                    'How it works',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to sample scripts
                  },
                  icon: CustomIconWidget(
                    iconName: 'library_books',
                    color: AppTheme.textSecondary,
                    size: 16,
                  ),
                  label: Text(
                    'Sample scripts',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
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
