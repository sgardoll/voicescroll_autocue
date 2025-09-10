import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TextPreviewEditor extends StatefulWidget {
  final String initialText;
  final Function(String) onSave;
  final VoidCallback onCancel;

  const TextPreviewEditor({
    Key? key,
    required this.initialText,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<TextPreviewEditor> createState() => _TextPreviewEditorState();
}

class _TextPreviewEditorState extends State<TextPreviewEditor> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  bool _hasChanges = false;
  int _wordCount = 0;
  int _characterCount = 0;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
    _textController.addListener(_updateCounts);
    _updateCounts();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateCounts() {
    final text = _textController.text;
    final words =
        text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;

    setState(() {
      _wordCount = words;
      _characterCount = text.length;
      _hasChanges = text != widget.initialText;
    });
  }

  void _saveChanges() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Script cannot be empty'),
          backgroundColor: AppTheme.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    widget.onSave(_textController.text);
  }

  void _discardChanges() {
    if (_hasChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.darkTheme.colorScheme.secondary,
          title: Text(
            'Discard Changes?',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'You have unsaved changes. Are you sure you want to discard them?',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Keep Editing',
                style: TextStyle(color: AppTheme.accent),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onCancel();
              },
              child: Text(
                'Discard',
                style: TextStyle(color: AppTheme.error),
              ),
            ),
          ],
        ),
      );
    } else {
      widget.onCancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.secondary,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.border.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _discardChanges,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textPrimary,
                      size: 6.w,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Preview & Edit',
                          style: AppTheme.darkTheme.textTheme.titleLarge,
                        ),
                        if (_hasChanges)
                          Text(
                            'Unsaved changes',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.warning,
                            ),
                          ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _saveChanges,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: AppTheme.accent,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Stats bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.secondary
                    .withValues(alpha: 0.5),
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.border.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  _buildStatItem('Words', _wordCount.toString()),
                  SizedBox(width: 4.w),
                  _buildStatItem('Characters', _characterCount.toString()),
                  Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: AppTheme.accent,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '~${(_wordCount / 150).ceil()} min read',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Text editor
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4.w),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Edit your script content here...',
                    hintStyle:
                        AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary.withValues(alpha: 0.7),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),

            // Bottom toolbar
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.secondary,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.border.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Quick actions
                  TextButton.icon(
                    onPressed: () {
                      _textController.text = _textController.text.toUpperCase();
                    },
                    icon: CustomIconWidget(
                      iconName: 'text_format',
                      color: AppTheme.textSecondary,
                      size: 4.w,
                    ),
                    label: Text(
                      'UPPERCASE',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  TextButton.icon(
                    onPressed: () {
                      final words = _textController.text.split(' ');
                      final titleCase = words.map((word) {
                        if (word.isEmpty) return word;
                        return word[0].toUpperCase() +
                            word.substring(1).toLowerCase();
                      }).join(' ');
                      _textController.text = titleCase;
                    },
                    icon: CustomIconWidget(
                      iconName: 'title',
                      color: AppTheme.textSecondary,
                      size: 4.w,
                    ),
                    label: Text(
                      'Title Case',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Spacer(),
                  // Save/Cancel buttons
                  Row(
                    children: [
                      TextButton(
                        onPressed: _discardChanges,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accent,
                          foregroundColor: AppTheme.textPrimary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 1.5.h),
                        ),
                        child: Text('Save Script'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
