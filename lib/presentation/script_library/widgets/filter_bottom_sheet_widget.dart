import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum SortOption { recent, alphabetical, wordCount, dateCreated }

class FilterBottomSheetWidget extends StatefulWidget {
  final SortOption currentSort;
  final bool isGridView;
  final Function(SortOption) onSortChanged;
  final Function(bool) onViewModeChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentSort,
    required this.isGridView,
    required this.onSortChanged,
    required this.onViewModeChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late SortOption _selectedSort;
  late bool _isGridView;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSort;
    _isGridView = widget.isGridView;
  }

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter & Sort',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: AppTheme.border, height: 1),

          // Sort Options
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort by',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildSortOption(
                  SortOption.recent,
                  'Recent',
                  'access_time',
                ),
                _buildSortOption(
                  SortOption.alphabetical,
                  'Alphabetical',
                  'sort_by_alpha',
                ),
                _buildSortOption(
                  SortOption.wordCount,
                  'Word Count',
                  'format_list_numbered',
                ),
                _buildSortOption(
                  SortOption.dateCreated,
                  'Date Created',
                  'calendar_today',
                ),
              ],
            ),
          ),

          Divider(color: AppTheme.border, height: 1),

          // View Mode
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View Mode',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildViewModeOption(
                        false,
                        'List View',
                        'view_list',
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildViewModeOption(
                        true,
                        'Grid View',
                        'view_module',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildSortOption(SortOption option, String title, String iconName) {
    final isSelected = _selectedSort == option;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSort = option;
        });
        widget.onSortChanged(option);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accent.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.accent : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: isSelected ? AppTheme.accent : AppTheme.textPrimary,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check',
                color: AppTheme.accent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewModeOption(bool isGrid, String title, String iconName) {
    final isSelected = _isGridView == isGrid;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isGridView = isGrid;
        });
        widget.onViewModeChanged(isGrid);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accent.withValues(alpha: 0.1)
              : AppTheme.primary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
