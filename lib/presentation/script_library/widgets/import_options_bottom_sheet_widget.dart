import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImportOptionsBottomSheetWidget extends StatelessWidget {
  final VoidCallback onCameraScan;
  final VoidCallback onFilesApp;
  final VoidCallback onCloudStorage;
  final VoidCallback onCreateNew;

  const ImportOptionsBottomSheetWidget({
    super.key,
    required this.onCameraScan,
    required this.onFilesApp,
    required this.onCloudStorage,
    required this.onCreateNew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Import Script',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Import Options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                _buildImportOption(
                  context,
                  icon: 'camera_alt',
                  title: 'Camera Scan',
                  subtitle: 'Scan text from documents or images',
                  onTap: () {
                    Navigator.pop(context);
                    onCameraScan();
                  },
                ),
                _buildImportOption(
                  context,
                  icon: 'folder',
                  title: 'Files App',
                  subtitle: 'Import from device storage',
                  onTap: () {
                    Navigator.pop(context);
                    onFilesApp();
                  },
                ),
                _buildImportOption(
                  context,
                  icon: 'cloud',
                  title: 'Cloud Storage',
                  subtitle: 'Import from Google Drive or Dropbox',
                  onTap: () {
                    Navigator.pop(context);
                    onCloudStorage();
                  },
                ),
                _buildImportOption(
                  context,
                  icon: 'add',
                  title: 'Create New',
                  subtitle: 'Start with a blank script',
                  onTap: () {
                    Navigator.pop(context);
                    onCreateNew();
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildImportOption(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.accent,
                size: 24,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
