import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilePickerWidget extends StatefulWidget {
  final Function(String) onFileSelected;
  final VoidCallback onClose;

  const FilePickerWidget({
    Key? key,
    required this.onFileSelected,
    required this.onClose,
  }) : super(key: key);

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  bool _isProcessing = false;
  String? _selectedFileName;

  Future<void> _pickFile() async {
    try {
      setState(() {
        _isProcessing = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'docx', 'pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _selectedFileName = file.name;
        });

        // Simulate file processing
        await Future.delayed(Duration(seconds: 1));

        String content;
        if (file.extension?.toLowerCase() == 'txt') {
          content = await _processTxtFile(file);
        } else if (file.extension?.toLowerCase() == 'docx') {
          content = await _processDocxFile(file);
        } else if (file.extension?.toLowerCase() == 'pdf') {
          content = await _processPdfFile(file);
        } else {
          content = 'Unsupported file format';
        }

        widget.onFileSelected(content);
      }
    } catch (e) {
      debugPrint('File picker error: $e');
      _showErrorMessage('Failed to process file. Please try again.');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<String> _processTxtFile(PlatformFile file) async {
    // Mock text file content
    return """Professional Presentation Script

Good morning, everyone. Thank you for joining us today for this important presentation about the future of digital communication and teleprompter technology.

In today's fast-paced world, effective communication is more crucial than ever. Whether you're delivering a keynote speech, recording a video presentation, or conducting a live broadcast, having the right tools can make all the difference.

Our VoiceScroll Autocue application represents a breakthrough in teleprompter technology, combining advanced speech recognition with intuitive user interface design to create a seamless presentation experience.

Key benefits include:
• Hands-free operation through voice recognition
• Real-time text synchronization
• Professional-grade formatting options
• Multi-platform compatibility
• Offline functionality for reliable performance

As we move forward, we're committed to continuously improving our platform based on user feedback and emerging technologies. Thank you for your attention, and I look forward to your questions.""";
  }

  Future<String> _processDocxFile(PlatformFile file) async {
    // Mock DOCX file content
    return """Corporate Training Module: Effective Communication

Module Overview:
This training module focuses on developing professional communication skills for corporate environments. Participants will learn techniques for clear, confident presentation delivery.

Learning Objectives:
1. Master the fundamentals of public speaking
2. Develop confidence in presentation delivery
3. Learn to use teleprompter technology effectively
4. Practice voice modulation and pacing
5. Understand audience engagement techniques

Section 1: Preparation Techniques
Effective preparation is the foundation of successful presentations. Begin by understanding your audience, organizing your content logically, and practicing your delivery multiple times.

Section 2: Technology Integration
Modern presentation tools, including teleprompter applications like VoiceScroll Autocue, can significantly enhance your delivery. These tools allow for natural, conversational presentation while maintaining eye contact with your audience.

Section 3: Practice Exercises
Regular practice with teleprompter technology helps develop natural rhythm and timing. Start with slower speeds and gradually increase as you become more comfortable with the technology.

Conclusion:
Mastering these skills takes time and practice, but the investment in professional communication abilities pays dividends throughout your career.""";
  }

  Future<String> _processPdfFile(PlatformFile file) async {
    // Mock PDF file content
    return """Research Paper: Voice Recognition in Digital Media

Abstract:
This paper examines the evolution of voice recognition technology in digital media applications, with particular focus on teleprompter systems and their impact on professional broadcasting.

Introduction:
Voice recognition technology has transformed how we interact with digital devices. In the context of teleprompter applications, this technology enables hands-free operation and natural presentation flow.

Methodology:
Our research involved analyzing user interaction patterns with voice-controlled teleprompter systems over a six-month period. Participants included professional broadcasters, content creators, and public speakers.

Results:
The study revealed significant improvements in presentation quality when using voice-controlled teleprompter systems. Key findings include:
• 40% reduction in presentation errors
• 60% improvement in natural delivery
• 85% user satisfaction rate
• 25% faster content delivery

Discussion:
These results suggest that voice recognition technology significantly enhances the teleprompter experience. The natural interaction model reduces cognitive load, allowing presenters to focus on content delivery rather than technical operation.

Future Research:
Further investigation into multi-language support and accent recognition will expand the accessibility and effectiveness of voice-controlled teleprompter systems.

Conclusion:
Voice recognition technology represents a significant advancement in teleprompter applications, offering improved usability and presentation quality for professional users.""";
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.secondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),

          // Header
          Row(
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
                  'Select File',
                  style: AppTheme.darkTheme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 12.w),
            ],
          ),
          SizedBox(height: 4.h),

          // Content
          Expanded(
            child: _isProcessing
                ? _buildProcessingView()
                : _buildFileSelectionView(),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.accent,
            strokeWidth: 3,
          ),
          SizedBox(height: 3.h),
          Text(
            'Processing file...',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          if (_selectedFileName != null)
            Text(
              _selectedFileName!,
              style: AppTheme.darkTheme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildFileSelectionView() {
    return Column(
      children: [
        // File type info
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.accent.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.accent,
                size: 6.w,
              ),
              SizedBox(height: 2.h),
              Text(
                'Supported File Types',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.accent,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'TXT, DOCX, PDF files are supported',
                style: AppTheme.darkTheme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),

        // File selection button
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _pickFile,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.accent,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'upload_file',
                            color: AppTheme.accent,
                            size: 12.w,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Select File',
                            style: AppTheme.darkTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Tap to browse files on your device',
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
