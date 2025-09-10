import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImportMethodSelector extends StatelessWidget {
  final Function(String) onMethodSelected;

  const ImportMethodSelector({
    Key? key,
    required this.onMethodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.secondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Import Script',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 3.h),
          _buildMethodOption(
            icon: 'camera_alt',
            title: 'Scan Document',
            subtitle: 'Use camera to scan text',
            onTap: () => onMethodSelected('camera'),
          ),
          _buildMethodOption(
            icon: 'folder',
            title: 'Select File',
            subtitle: 'Choose from device storage',
            onTap: () => onMethodSelected('file'),
          ),
          _buildMethodOption(
            icon: 'cloud',
            title: 'Cloud Storage',
            subtitle: 'Import from cloud services',
            onTap: () => onMethodSelected('cloud'),
          ),
          _buildMethodOption(
            icon: 'edit',
            title: 'Manual Entry',
            subtitle: 'Type or paste text',
            onTap: () => onMethodSelected('manual'),
          ),
          _buildMethodOption(
            icon: 'mic',
            title: 'Voice to Text',
            subtitle: 'Dictate your script',
            onTap: () => onMethodSelected('voice'),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildMethodOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.darkTheme.colorScheme.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.border.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: icon,
                      color: AppTheme.accent,
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.darkTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle,
                        style: AppTheme.darkTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
