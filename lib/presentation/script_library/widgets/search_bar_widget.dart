import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onVoiceSearch;
  final VoidCallback onFilterTap;

  const SearchBarWidget({
    super.key,
    required this.onSearchChanged,
    required this.onVoiceSearch,
    required this.onFilterTap,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isListening = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: AppTheme.darkTheme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search scripts...',
                  hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            widget.onSearchChanged('');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(2.w),
                            child: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme.textSecondary,
                              size: 18,
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: _handleVoiceSearch,
                        child: Container(
                          margin: EdgeInsets.only(right: 3.w),
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: _isListening
                                ? AppTheme.accent.withValues(alpha: 0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: _isListening ? 'mic' : 'mic_none',
                            color: _isListening
                                ? AppTheme.accent
                                : AppTheme.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
                onChanged: widget.onSearchChanged,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: widget.onFilterTap,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'tune',
                color: AppTheme.textPrimary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleVoiceSearch() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      // Simulate voice recognition for 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
          // Simulate voice input result
          _searchController.text = 'presentation script';
          widget.onSearchChanged(_searchController.text);
        }
      });
    }

    widget.onVoiceSearch();
  }
}
