import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceTestWidget extends StatefulWidget {
  const VoiceTestWidget({Key? key}) : super(key: key);

  @override
  State<VoiceTestWidget> createState() => _VoiceTestWidgetState();
}

class _VoiceTestWidgetState extends State<VoiceTestWidget>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _hasPermission = false;
  double _audioLevel = 0.0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _checkPermission();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.microphone.status;
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  Future<void> _requestPermission() async {
    final status = await Permission.microphone.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  Future<void> _startRecording() async {
    if (!_hasPermission) {
      await _requestPermission();
      if (!_hasPermission) return;
    }

    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ), path: 'temp_recording.aac');

        setState(() {
          _isRecording = true;
        });

        _pulseController.repeat(reverse: true);
        _simulateAudioLevel();
      }
    } catch (e) {
      _showError('Failed to start recording: \${e.toString()}');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _audioLevel = 0.0;
      });
      _pulseController.stop();
      _pulseController.reset();
    } catch (e) {
      _showError('Failed to stop recording: \${e.toString()}');
    }
  }

  void _simulateAudioLevel() {
    if (!_isRecording) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isRecording) {
        setState(() {
          _audioLevel = (0.2 +
              (0.8 * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000));
        });
        _simulateAudioLevel();
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isRecording ? AppTheme.accent : AppTheme.border,
          width: _isRecording ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'mic',
                color: _isRecording ? AppTheme.accent : AppTheme.textSecondary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Microphone Test',
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _isRecording
                          ? 'Recording... Speak now'
                          : 'Test your microphone quality',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isRecording ? _pulseAnimation.value : 1.0,
                    child: GestureDetector(
                      onTap: _isRecording ? _stopRecording : _startRecording,
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color:
                              _isRecording ? AppTheme.error : AppTheme.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: _isRecording ? 'stop' : 'play_arrow',
                            color: AppTheme.textPrimary,
                            size: 6.w,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          if (_isRecording) ...[
            SizedBox(height: 3.h),
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _audioLevel,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        _audioLevel > 0.7 ? AppTheme.success : AppTheme.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Audio Level: \${(_audioLevel * 100).toInt()}%',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}