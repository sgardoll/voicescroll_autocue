import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSliderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconName;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final String Function(double)? valueFormatter;
  final bool showDivider;
  final Color? iconColor;

  const SettingsSliderWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.iconName,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.valueFormatter,
    this.showDivider = true,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              Row(
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
                  Text(
                    valueFormatter?.call(value) ?? value.toStringAsFixed(1),
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.accent,
                  inactiveTrackColor: AppTheme.border,
                  thumbColor: AppTheme.accent,
                  overlayColor: AppTheme.accent.withValues(alpha: 0.2),
                  trackHeight: 3,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: onChanged,
                ),
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
