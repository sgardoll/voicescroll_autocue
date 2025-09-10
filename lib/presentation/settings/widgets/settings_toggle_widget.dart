import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsToggleWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconName;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;
  final Color? iconColor;

  const SettingsToggleWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.iconName,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          child: Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppTheme.accent).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: iconColor ?? AppTheme.accent,
                    size: 4.w,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle!,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppTheme.accent,
                inactiveThumbColor: AppTheme.textSecondary,
                inactiveTrackColor: AppTheme.border,
              ),
            ],
          ),
        ),
        if (showDivider)
          Container(
            margin: EdgeInsets.only(left: 15.w),
            height: 1,
            color: AppTheme.border.withValues(alpha: 0.3),
          ),
      ],
    );
  }
}
