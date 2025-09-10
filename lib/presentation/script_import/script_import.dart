import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_scanner.dart';
import './widgets/cloud_storage_selector.dart';
import './widgets/file_picker_widget.dart';
import './widgets/import_method_selector.dart';
import './widgets/manual_text_editor.dart';
import './widgets/text_preview_editor.dart';
import './widgets/voice_to_text_recorder.dart';

class ScriptImport extends StatefulWidget {
  const ScriptImport({Key? key}) : super(key: key);

  @override
  State<ScriptImport> createState() => _ScriptImportState();
}

class _ScriptImportState extends State<ScriptImport> {
  String _currentStep = 'method_selection';
  String? _importedText;
  String? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.darkTheme.colorScheme.surface,
                  AppTheme.darkTheme.colorScheme.secondary
                      .withValues(alpha: 0.3),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header with progress
                _buildHeader(),

                // Content area
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Top bar with close button
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleClose,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.darkTheme.colorScheme.secondary
                          .withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textPrimary,
                      size: 6.w,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Import Script',
                  style: AppTheme.darkTheme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 12.w),
            ],
          ),

          SizedBox(height: 3.h),

          // Progress indicator
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final steps = ['Select Method', 'Import Content', 'Preview & Edit'];
    int currentStepIndex = 0;

    switch (_currentStep) {
      case 'method_selection':
        currentStepIndex = 0;
        break;
      case 'importing':
        currentStepIndex = 1;
        break;
      case 'preview':
        currentStepIndex = 2;
        break;
    }

    return Column(
      children: [
        // Progress bar
        Container(
          height: 0.5.h,
          decoration: BoxDecoration(
            color: AppTheme.border.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                  decoration: BoxDecoration(
                    color: index <= currentStepIndex
                        ? AppTheme.accent
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),

        SizedBox(height: 2.h),

        // Step labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isActive = index <= currentStepIndex;

            return Expanded(
              child: Text(
                step,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: isActive ? AppTheme.accent : AppTheme.textSecondary,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                ),
                textAlign: index == 0
                    ? TextAlign.start
                    : index == 1
                        ? TextAlign.center
                        : TextAlign.end,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_currentStep) {
      case 'method_selection':
        return _buildMethodSelection();
      case 'importing':
        return _buildImportingContent();
      case 'preview':
        return _buildPreviewContent();
      default:
        return _buildMethodSelection();
    }
  }

  Widget _buildMethodSelection() {
    return Column(
      children: [
        // Welcome message
        Container(
          margin: EdgeInsets.all(4.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color:
                AppTheme.darkTheme.colorScheme.secondary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: 'upload',
                color: AppTheme.accent,
                size: 8.w,
              ),
              SizedBox(height: 2.h),
              Text(
                'Choose Import Method',
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              Text(
                'Select how you\'d like to add your script content to VoiceScroll Autocue',
                style: AppTheme.darkTheme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        Spacer(),

        // Method selection bottom sheet trigger
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(4.w),
          child: ElevatedButton(
            onPressed: _showMethodSelector,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.textPrimary,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.textPrimary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Select Import Method',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImportingContent() {
    switch (_selectedMethod) {
      case 'camera':
        return CameraScanner(
          onTextRecognized: _handleTextImported,
          onClose: _handleClose,
        );
      case 'file':
        return FilePickerWidget(
          onFileSelected: _handleTextImported,
          onClose: _handleClose,
        );
      case 'cloud':
        return CloudStorageSelector(
          onFileSelected: _handleTextImported,
          onClose: _handleClose,
        );
      case 'manual':
        return ManualTextEditor(
          onTextSaved: _handleTextImported,
          onClose: _handleClose,
        );
      case 'voice':
        return VoiceToTextRecorder(
          onTextRecognized: _handleTextImported,
          onClose: _handleClose,
        );
      default:
        return _buildMethodSelection();
    }
  }

  Widget _buildPreviewContent() {
    if (_importedText == null) {
      return _buildMethodSelection();
    }

    return TextPreviewEditor(
      initialText: _importedText!,
      onSave: _handleScriptSaved,
      onCancel: () {
        setState(() {
          _currentStep = 'method_selection';
          _importedText = null;
          _selectedMethod = null;
        });
      },
    );
  }

  void _showMethodSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ImportMethodSelector(
        onMethodSelected: _handleMethodSelected,
      ),
    );
  }

  void _handleMethodSelected(String method) {
    Navigator.pop(context); // Close bottom sheet
    setState(() {
      _selectedMethod = method;
      _currentStep = 'importing';
    });
  }

  void _handleTextImported(String text) {
    setState(() {
      _importedText = text;
      _currentStep = 'preview';
    });
  }

  void _handleScriptSaved(String finalText) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.success,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Script imported successfully!',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.success.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Start Session',
          textColor: AppTheme.textPrimary,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/teleprompter-view');
          },
        ),
      ),
    );

    // Navigate back to script library after a delay
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/script-library');
      }
    });
  }

  void _handleClose() {
    if (_currentStep == 'preview' && _importedText != null) {
      // Show confirmation dialog for unsaved changes
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.darkTheme.colorScheme.secondary,
          title: Text(
            'Discard Import?',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'You have imported content that hasn\'t been saved. Are you sure you want to discard it?',
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
                Navigator.pushReplacementNamed(context, '/script-library');
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
      Navigator.pushReplacementNamed(context, '/script-library');
    }
  }
}
