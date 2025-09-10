import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ManualTextEditor extends StatefulWidget {
  final Function(String) onTextSaved;
  final VoidCallback onClose;

  const ManualTextEditor({
    Key? key,
    required this.onTextSaved,
    required this.onClose,
  }) : super(key: key);

  @override
  State<ManualTextEditor> createState() => _ManualTextEditorState();
}

class _ManualTextEditorState extends State<ManualTextEditor> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isBold = false;
  bool _isItalic = false;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateWordCount);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateWordCount() {
    final text = _textController.text.trim();
    final words = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    setState(() {
      _wordCount = words;
    });
  }

  void _pasteFromClipboard() async {
    // Simulate paste functionality
    const sampleText = """Welcome to VoiceScroll Autocue

This is sample text that demonstrates the manual text entry feature. You can type, edit, and format your script content directly in this editor.

Key features available:
• Real-time word count
• Text formatting options
• Paste functionality
• Auto-save capabilities

Your script content will be automatically saved as you type, ensuring no work is lost during the editing process.""";

    _textController.text = sampleText;
    _focusNode.requestFocus();
  }

  void _clearText() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.secondary,
        title: Text(
          'Clear Text',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to clear all text? This action cannot be undone.',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              _textController.clear();
              Navigator.pop(context);
            },
            child: Text(
              'Clear',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _saveText() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter some text before saving'),
          backgroundColor: AppTheme.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    widget.onTextSaved(_textController.text);
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
                    onPressed: widget.onClose,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textPrimary,
                      size: 6.w,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Manual Entry',
                      style: AppTheme.darkTheme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    onPressed: _saveText,
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

            // Formatting toolbar
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
                  _buildFormatButton(
                    icon: 'format_bold',
                    isActive: _isBold,
                    onTap: () => setState(() => _isBold = !_isBold),
                  ),
                  SizedBox(width: 2.w),
                  _buildFormatButton(
                    icon: 'format_italic',
                    isActive: _isItalic,
                    onTap: () => setState(() => _isItalic = !_isItalic),
                  ),
                  SizedBox(width: 4.w),
                  _buildActionButton(
                    icon: 'content_paste',
                    label: 'Paste',
                    onTap: _pasteFromClipboard,
                  ),
                  Spacer(),
                  _buildActionButton(
                    icon: 'clear',
                    label: 'Clear',
                    onTap: _clearText,
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
                    fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                    fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                    height: 1.6,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'Start typing your script here...\n\nYou can paste text, format it, and see the word count update in real-time.',
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
                          iconName: 'text_fields',
                          color: AppTheme.accent,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '$_wordCount words',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      TextButton(
                        onPressed: widget.onClose,
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
                        onPressed: _saveText,
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

  Widget _buildFormatButton({
    required String icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.accent.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isActive
                ? Border.all(
                    color: AppTheme.accent.withValues(alpha: 0.5), width: 1)
                : null,
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: isActive ? AppTheme.accent : AppTheme.textSecondary,
            size: 5.w,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: icon,
                color: AppTheme.textSecondary,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                label,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
