import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? value;
  final String iconName;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showDivider;
  final Color? iconColor;

  const SettingsItemWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.value,
    required this.iconName,
    this.onTap,
    this.trailing,
    this.showDivider = true,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color:
                          (iconColor ?? AppTheme.accent).withValues(alpha: 0.1),
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
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            subtitle!,
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (value != null) ...[
                    Text(
                      value!,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(width: 2.w),
                  ],
                  if (trailing != null)
                    trailing!
                  else if (onTap != null)
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.textSecondary,
                      size: 4.w,
                    ),
                ],
              ),
            ),
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
