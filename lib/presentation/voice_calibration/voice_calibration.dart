import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/calibration_controls_widget.dart';
import './widgets/calibration_progress_widget.dart';
import './widgets/microphone_visualization_widget.dart';
import './widgets/sample_text_widget.dart';
import './widgets/sensitivity_control_widget.dart';

class VoiceCalibration extends StatefulWidget {
  const VoiceCalibration({Key? key}) : super(key: key);

  @override
  State<VoiceCalibration> createState() => _VoiceCalibrationState();
}

class _VoiceCalibrationState extends State<VoiceCalibration>
    with TickerProviderStateMixin {
  // Calibration state
  int _currentStep = 1;
  final int _totalSteps = 5;
  bool _isListening = false;
  bool _isPaused = false;
  double _audioLevel = 0.0;
  double _recognitionConfidence = 0.0;
  double _sensitivity = 0.5;
  String _detectedEnvironment = '';

  // Audio recording
  late AudioRecorder _audioRecorder;
  bool _hasPermission = false;

  // Sample texts for calibration
  final List<String> _sampleTexts = [
    'Welcome to voice calibration. Please read this text clearly and at your normal speaking pace.',
    'The quick brown fox jumps over the lazy dog. This sentence contains every letter of the alphabet.',
    'In a hole in the ground there lived a hobbit. Not a nasty, dirty, wet hole filled with the ends of worms.',
    'To be or not to be, that is the question. Whether tis nobler in the mind to suffer the slings and arrows.',
    'Four score and seven years ago our fathers brought forth on this continent a new nation conceived in liberty.',
  ];

  // Recognition state
  List<String> _recognizedWords = [];
  int _currentWordIndex = 0;

  // Instructions for each step
  final List<String> _instructions = [
    'Read the highlighted text aloud at your normal speaking pace.',
    'Continue reading clearly. We\'re analyzing your voice patterns.',
    'Great! Now read this passage to test different words.',
    'Almost done. Read this classic text for final calibration.',
    'Final step. Read this historical text to complete calibration.',
  ];

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _initializeCalibration();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _initializeCalibration() async {
    await _requestMicrophonePermission();
    _detectEnvironment();
  }

  Future<void> _requestMicrophonePermission() async {
    if (kIsWeb) {
      setState(() => _hasPermission = true);
      return;
    }

    final status = await Permission.microphone.request();
    setState(() => _hasPermission = status.isGranted);

    if (!_hasPermission) {
      _showPermissionDialog();
    }
  }

  void _detectEnvironment() {
    // Simulate environment detection based on sensitivity
    setState(() {
      if (_sensitivity <= 0.3) {
        _detectedEnvironment = 'Quiet office environment';
      } else if (_sensitivity <= 0.7) {
        _detectedEnvironment = 'Normal room environment';
      } else {
        _detectedEnvironment = 'Noisy environment detected';
      }
    });
  }

  Future<void> _startListening() async {
    if (!_hasPermission) {
      await _requestMicrophonePermission();
      return;
    }

    try {
      if (await _audioRecorder.hasPermission()) {
        if (kIsWeb) {
          // Web implementation - no path required, browser handles storage
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: '', // Empty string for web
          );
        } else {
          // Mobile implementation - specify file path
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/voice_calibration.wav';
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: filePath,
          );
        }
        setState(() {
          _isListening = true;
          _isPaused = false;
        });
        _simulateVoiceRecognition();
      }
    } catch (e) {
      _showErrorMessage('Failed to start voice recognition');
    }
  }

  Future<void> _stopListening() async {
    try {
      await _audioRecorder.stop();
      setState(() {
        _isListening = false;
        _isPaused = false;
        _audioLevel = 0.0;
      });
    } catch (e) {
      _showErrorMessage('Failed to stop voice recognition');
    }
  }

  void _pauseResume() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _simulateVoiceRecognition() {
    if (!_isListening || _isPaused) return;

    // Simulate audio level changes
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isListening && !_isPaused) {
        setState(() {
          _audioLevel = (0.3 +
              (DateTime.now().millisecondsSinceEpoch % 1000) / 1000 * 0.7);
          _recognitionConfidence =
              0.6 + (DateTime.now().millisecondsSinceEpoch % 500) / 500 * 0.4;
        });

        // Simulate word recognition
        if (_recognizedWords.length < _getCurrentText().split(' ').length) {
          if (DateTime.now().millisecondsSinceEpoch % 2000 < 100) {
            _recognizeNextWord();
          }
        }

        _simulateVoiceRecognition();
      }
    });
  }

  void _recognizeNextWord() {
    final words = _getCurrentText().split(' ');
    if (_currentWordIndex < words.length) {
      setState(() {
        _recognizedWords.add(words[_currentWordIndex]);
        _currentWordIndex++;

        // Auto-advance to next step when text is complete
        if (_recognizedWords.length == words.length) {
          Future.delayed(const Duration(seconds: 2), () {
            if (_currentStep < _totalSteps) {
              _nextStep();
            } else {
              _completeCalibration();
            }
          });
        }
      });
    }
  }

  String _getCurrentText() {
    return _sampleTexts[_currentStep - 1];
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
        _recognizedWords.clear();
        _currentWordIndex = 0;
      });
    }
  }

  void _skipStep() {
    _nextStep();
  }

  void _restartCalibration() {
    setState(() {
      _currentStep = 1;
      _recognizedWords.clear();
      _currentWordIndex = 0;
      _isListening = false;
      _isPaused = false;
      _audioLevel = 0.0;
      _recognitionConfidence = 0.0;
    });
  }

  void _completeCalibration() {
    _stopListening();
    _showCalibrationResults();
  }

  void _showCalibrationResults() {
    final accuracy = (_recognitionConfidence * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondary,
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.success,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Calibration Complete',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your voice recognition has been successfully calibrated!',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Accuracy Score:',
                        style: AppTheme.darkTheme.textTheme.bodyMedium
                            ?.copyWith(color: AppTheme.textSecondary),
                      ),
                      Text(
                        '$accuracy%',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: accuracy >= 80
                              ? AppTheme.success
                              : accuracy >= 60
                                  ? AppTheme.warning
                                  : AppTheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Environment:',
                        style: AppTheme.darkTheme.textTheme.bodyMedium
                            ?.copyWith(color: AppTheme.textSecondary),
                      ),
                      Text(
                        _detectedEnvironment.split(' ').first,
                        style: AppTheme.darkTheme.textTheme.bodyMedium
                            ?.copyWith(color: AppTheme.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              accuracy >= 80
                  ? 'Excellent! Your teleprompter will work optimally.'
                  : accuracy >= 60
                      ? 'Good calibration. Consider recalibrating in a quieter environment for better results.'
                      : 'Consider recalibrating in a quieter environment or adjusting sensitivity settings.',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          if (accuracy < 80) ...[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartCalibration();
              },
              child: Text(
                'Recalibrate',
                style: TextStyle(color: AppTheme.accent),
              ),
            ),
          ],
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/teleprompter-view');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
            ),
            child: Text(
              'Continue to Teleprompter',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondary,
        title: Text(
          'Microphone Permission Required',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Voice calibration requires microphone access to analyze your speech patterns and optimize recognition accuracy.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/settings');
            },
            child: Text(
              'Skip',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _requestMicrophonePermission();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
            ),
            child: Text(
              'Grant Permission',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
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
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/settings'),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimary,
            size: 6.w,
          ),
        ),
        title: Text(
          'Voice Calibration',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppTheme.secondary,
                  title: Text(
                    'Voice Calibration Help',
                    style: AppTheme.darkTheme.textTheme.titleMedium
                        ?.copyWith(color: AppTheme.textPrimary),
                  ),
                  content: Text(
                    'Voice calibration optimizes speech recognition for your voice and environment. Read each text passage clearly at your normal speaking pace. The system will learn your speech patterns and adjust sensitivity automatically.',
                    style: AppTheme.darkTheme.textTheme.bodyMedium
                        ?.copyWith(color: AppTheme.textPrimary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Got it',
                        style: TextStyle(color: AppTheme.accent),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.textSecondary,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // Progress indicator
              CalibrationProgressWidget(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
                instruction: _instructions[_currentStep - 1],
              ),

              SizedBox(height: 4.h),

              // Microphone visualization
              MicrophoneVisualizationWidget(
                isListening: _isListening && !_isPaused,
                audioLevel: _audioLevel,
                recognitionConfidence: _recognitionConfidence,
              ),

              SizedBox(height: 4.h),

              // Sample text
              SampleTextWidget(
                fullText: _getCurrentText(),
                recognizedWords: _recognizedWords,
                currentWordIndex: _currentWordIndex,
              ),

              SizedBox(height: 4.h),

              // Sensitivity control
              SensitivityControlWidget(
                sensitivity: _sensitivity,
                onSensitivityChanged: (value) {
                  setState(() => _sensitivity = value);
                  _detectEnvironment();
                },
                environment: _detectedEnvironment,
              ),

              SizedBox(height: 4.h),

              // Control buttons
              CalibrationControlsWidget(
                isListening: _isListening,
                isPaused: _isPaused,
                onStartStop: _isListening ? _stopListening : _startListening,
                onPauseResume: _pauseResume,
                onSkip: _skipStep,
                onRestart: _restartCalibration,
                canSkip: _currentStep < _totalSteps,
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
