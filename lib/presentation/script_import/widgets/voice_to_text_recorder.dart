import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceToTextRecorder extends StatefulWidget {
  final Function(String) onTextRecognized;
  final VoidCallback onClose;

  const VoiceToTextRecorder({
    Key? key,
    required this.onTextRecognized,
    required this.onClose,
  }) : super(key: key);

  @override
  State<VoiceToTextRecorder> createState() => _VoiceToTextRecorderState();
}

class _VoiceToTextRecorderState extends State<VoiceToTextRecorder>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isProcessing = false;
  String _recognizedText = '';
  Duration _recordingDuration = Duration.zero;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb) return true;
    return (await Permission.microphone.request()).isGranted;
  }

  Future<void> _startRecording() async {
    try {
      if (!await _requestMicrophonePermission()) {
        _showErrorMessage(
            'Microphone permission is required for voice recording');
        return;
      }

      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
          _recordingDuration = Duration.zero;
          _recognizedText = '';
        });

        _pulseController.repeat();
        _waveController.repeat();

        if (kIsWeb) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'recording.wav',
          );
        } else {
          await _audioRecorder.start(
            const RecordConfig(),
            path: 'recording.wav',
          );
        }

        // Start duration timer
        _startDurationTimer();
      }
    } catch (e) {
      debugPrint('Recording start error: $e');
      _showErrorMessage('Failed to start recording. Please try again.');
    }
  }

  void _startDurationTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingDuration = _recordingDuration + Duration(seconds: 1);
        });
        _startDurationTimer();
      }
    });
  }

  Future<void> _stopRecording() async {
    try {
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      _pulseController.stop();
      _waveController.stop();

      final String? path = await _audioRecorder.stop();

      if (path != null) {
        // Simulate speech-to-text processing
        await Future.delayed(Duration(seconds: 3));

        // Mock speech recognition result
        const mockTranscription =
            """Good morning everyone, and welcome to today's presentation about the future of voice-controlled technology in professional environments.

Voice recognition has revolutionized how we interact with digital devices, and teleprompter applications represent one of the most practical implementations of this technology.

Our VoiceScroll Autocue application demonstrates the power of hands-free operation, allowing presenters to focus entirely on their delivery while the system automatically scrolls through their content based on their speaking pace.

Key advantages of voice-controlled teleprompters include improved eye contact with the audience, natural presentation flow, and reduced reliance on manual controls that can be distracting during important presentations.

As we continue to advance this technology, we're seeing increased adoption across various industries, from broadcasting and corporate communications to education and public speaking.

Thank you for your attention, and I look forward to demonstrating these capabilities in our upcoming product showcase.""";

        setState(() {
          _recognizedText = mockTranscription;
        });

        widget.onTextRecognized(mockTranscription);
      }
    } catch (e) {
      debugPrint('Recording stop error: $e');
      _showErrorMessage('Failed to process recording. Please try again.');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
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
                  'Voice to Text',
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
            child:
                _isProcessing ? _buildProcessingView() : _buildRecordingView(),
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
            'Processing speech...',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Converting your voice to text',
            style: AppTheme.darkTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingView() {
    return Column(
      children: [
        // Instructions
        if (!_isRecording)
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
                  iconName: 'tips_and_updates',
                  color: AppTheme.accent,
                  size: 6.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Voice Recording Tips',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.accent,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Speak clearly and at a normal pace\n• Find a quiet environment\n• Hold device at comfortable distance\n• Pause between sentences for better accuracy',
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),

        SizedBox(height: 4.h),

        // Recording interface
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Recording button with animation
                GestureDetector(
                  onTap: _isRecording ? _stopRecording : _startRecording,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _isRecording ? AppTheme.error : AppTheme.accent,
                          boxShadow: _isRecording
                              ? [
                                  BoxShadow(
                                    color:
                                        AppTheme.error.withValues(alpha: 0.3),
                                    blurRadius:
                                        20 * (1 + _pulseController.value),
                                    spreadRadius: 5 * _pulseController.value,
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: _isRecording ? 'stop' : 'mic',
                            color: AppTheme.textPrimary,
                            size: 12.w,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 4.h),

                // Status text
                Text(
                  _isRecording ? 'Recording...' : 'Tap to start recording',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),

                SizedBox(height: 1.h),

                // Duration or instruction
                if (_isRecording)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 2.w,
                          height: 2.w,
                          decoration: BoxDecoration(
                            color: AppTheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          _formatDuration(_recordingDuration),
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    'Speak clearly for best results',
                    style: AppTheme.darkTheme.textTheme.bodySmall,
                  ),

                SizedBox(height: 4.h),

                // Wave animation during recording
                if (_isRecording)
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final delay = index * 0.2;
                          final animValue =
                              (_waveController.value + delay) % 1.0;
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            width: 1.w,
                            height: 8.h * (0.3 + 0.7 * animValue),
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(0.5.w),
                            ),
                          );
                        }),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}