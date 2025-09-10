import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SensitivityControlWidget extends StatelessWidget {
  final double sensitivity;
  final Function(double) onSensitivityChanged;
  final String environment;

  const SensitivityControlWidget({
    Key? key,
    required this.sensitivity,
    required this.onSensitivityChanged,
    required this.environment,
  }) : super(key: key);

  String _getSensitivityLabel(double value) {
    if (value <= 0.3) return 'Quiet';
    if (value <= 0.7) return 'Normal';
    return 'Loud';
  }

  Color _getSensitivityColor(double value) {
    if (value <= 0.3) return AppTheme.success;
    if (value <= 0.7) return AppTheme.accent;
    return AppTheme.warning;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Voice Sensitivity',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color:
                      _getSensitivityColor(sensitivity).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getSensitivityColor(sensitivity),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getSensitivityLabel(sensitivity),
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: _getSensitivityColor(sensitivity),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Environment labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEnvironmentLabel('Quiet', 0.2, sensitivity <= 0.3),
              _buildEnvironmentLabel(
                  'Normal', 0.5, sensitivity > 0.3 && sensitivity <= 0.7),
              _buildEnvironmentLabel('Loud', 0.8, sensitivity > 0.7),
            ],
          ),
          SizedBox(height: 1.h),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getSensitivityColor(sensitivity),
              thumbColor: _getSensitivityColor(sensitivity),
              overlayColor:
                  _getSensitivityColor(sensitivity).withValues(alpha: 0.2),
              inactiveTrackColor: AppTheme.border,
              trackHeight: 0.8.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2.w),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 4.w),
            ),
            child: Slider(
              value: sensitivity,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              onChanged: onSensitivityChanged,
            ),
          ),
          SizedBox(height: 2.h),

          // Current environment indicator
          if (environment.isNotEmpty) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.accent,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Detected environment: $environment',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEnvironmentLabel(String label, double value, bool isActive) {
    return Column(
      children: [
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
            color:
                isActive ? _getSensitivityColor(value) : AppTheme.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          width: 1.w,
          height: 1.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? _getSensitivityColor(value) : AppTheme.border,
          ),
        ),
      ],
    );
  }
}
