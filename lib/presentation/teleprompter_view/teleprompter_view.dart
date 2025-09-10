import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/teleprompter_controls_widget.dart';
import './widgets/teleprompter_progress_widget.dart';
import './widgets/teleprompter_text_widget.dart';
import './widgets/voice_command_indicator_widget.dart';

class TeleprompterView extends StatefulWidget {
  const TeleprompterView({Key? key}) : super(key: key);

  @override
  State<TeleprompterView> createState() => _TeleprompterViewState();
}

class _TeleprompterViewState extends State<TeleprompterView>
    with TickerProviderStateMixin {
  // Controllers and Animation
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  Timer? _autoHideTimer;
  Timer? _scrollTimer;
  Timer? _voiceRecognitionTimer;

  // Teleprompter State
  bool _isPlaying = false;
  bool _isListening = false;
  bool _controlsVisible = true;
  double _scrollSpeed = 1.0;
  double _fontSize = 24.0;
  int _currentWordIndex = 0;
  double _progress = 0.0;
  String? _lastVoiceCommand;

  // Voice Recognition State
  bool _voiceRecognitionActive = false;
  List<String> _recognizedWords = [];

  // Mock Script Data
  final String _scriptText =
      """Welcome to VoiceScroll Autocue, the professional teleprompter application designed for seamless content delivery. This innovative tool combines advanced voice recognition technology with intuitive scrolling controls to provide hands-free operation for presenters, content creators, and public speakers.

The application features real-time speech recognition that automatically advances the text as you speak, ensuring perfect synchronization between your delivery and the displayed content. With customizable text sizing, adjustable scroll speeds, and voice command integration, you can maintain natural eye contact with your audience while delivering flawless presentations.

Key features include full-screen immersive mode, automatic text highlighting for current position tracking, and intelligent pause detection. The system adapts to your speaking pace and provides manual override controls when needed. Voice commands such as 'pause teleprompter', 'resume', 'faster', and 'slower' allow complete hands-free operation.

Whether you're recording video content, delivering live presentations, or conducting training sessions, VoiceScroll Autocue ensures professional results every time. The application supports both portrait and landscape orientations, maintains screen wake lock during sessions, and provides comprehensive session statistics for performance analysis.

Experience the future of teleprompter technology with VoiceScroll Autocue - where voice meets precision in content delivery.""";

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _enterImmersiveMode();
    _startAutoHideTimer();
    _simulateVoiceRecognition();
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController.forward();
  }

  void _enterImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _exitImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _startAutoHideTimer() {
    _autoHideTimer?.cancel();
    _autoHideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _controlsVisible = false;
        });
      }
    });
  }

  void _showControls() {
    setState(() {
      _controlsVisible = true;
    });
    _startAutoHideTimer();
  }

  void _simulateVoiceRecognition() {
    _voiceRecognitionTimer = Timer.periodic(
      const Duration(milliseconds: 1500),
      (timer) {
        if (_isPlaying && _voiceRecognitionActive) {
          _processVoiceInput();
        }
      },
    );
  }

  void _processVoiceInput() {
    final words = _scriptText.split(' ');
    if (_currentWordIndex < words.length - 1) {
      setState(() {
        _currentWordIndex++;
        _progress = _currentWordIndex / words.length;
        _isListening = true;
      });

      // Simulate voice command recognition
      if (Random().nextDouble() < 0.1) {
        _processVoiceCommand();
      }

      _autoScrollToCurrentWord();

      // Reset listening indicator
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
        }
      });
    }
  }

  void _processVoiceCommand() {
    final commands = ['pause teleprompter', 'faster', 'slower', 'resume'];
    final command = commands[Random().nextInt(commands.length)];

    setState(() {
      _lastVoiceCommand = command;
    });

    switch (command) {
      case 'pause teleprompter':
        _togglePlayPause();
        break;
      case 'faster':
        _increaseSpeed();
        break;
      case 'slower':
        _decreaseSpeed();
        break;
      case 'resume':
        if (!_isPlaying) _togglePlayPause();
        break;
    }

    // Clear command after 2 seconds
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _lastVoiceCommand = null;
        });
      }
    });
  }

  void _autoScrollToCurrentWord() {
    if (_scrollController.hasClients) {
      final wordsPerLine = _calculateWordsPerLine();
      final currentLine = _currentWordIndex ~/ wordsPerLine;
      final lineHeight = _fontSize * 1.6;
      final targetOffset = currentLine * lineHeight;

      _scrollController.animateTo(
        targetOffset,
        duration: Duration(milliseconds: (800 / _scrollSpeed).round()),
        curve: Curves.easeInOut,
      );
    }
  }

  int _calculateWordsPerLine() {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - (8.w);
    final averageCharWidth = _fontSize * 0.6;
    final averageWordLength = 6;
    return (availableWidth / (averageCharWidth * averageWordLength)).floor();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _voiceRecognitionActive = _isPlaying;
    });
    _showControls();
  }

  void _increaseSpeed() {
    setState(() {
      _scrollSpeed = (_scrollSpeed + 0.1).clamp(0.1, 3.0);
    });
    _showControls();
  }

  void _decreaseSpeed() {
    setState(() {
      _scrollSpeed = (_scrollSpeed - 0.1).clamp(0.1, 3.0);
    });
    _showControls();
  }

  void _handleTextTap() {
    if (_isPlaying) {
      _togglePlayPause();
    }
    _showControls();
  }

  void _handleFontSizeChange(ScaleUpdateDetails details) {
    setState(() {
      _fontSize = (_fontSize * details.scale).clamp(16.0, 48.0);
    });
  }

  void _exitTeleprompter() {
    _exitImmersiveMode();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _autoHideTimer?.cancel();
    _scrollTimer?.cancel();
    _voiceRecognitionTimer?.cancel();
    _exitImmersiveMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Text Display
            GestureDetector(
              onScaleUpdate: _handleFontSizeChange,
              child: TeleprompterTextWidget(
                text: _scriptText,
                currentWordIndex: _currentWordIndex,
                fontSize: _fontSize,
                scrollController: _scrollController,
                onTap: _handleTextTap,
              ),
            ),

            // Progress Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TeleprompterProgressWidget(
                progress: _progress,
                isVisible: _controlsVisible,
              ),
            ),

            // Voice Command Indicator
            VoiceCommandIndicatorWidget(
              isListening: _isListening,
              lastCommand: _lastVoiceCommand,
              isVisible: _controlsVisible || _isListening,
            ),

            // Bottom Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: TeleprompterControlsWidget(
                isPlaying: _isPlaying,
                scrollSpeed: _scrollSpeed,
                onPlayPause: _togglePlayPause,
                onSpeedDecrease: _decreaseSpeed,
                onSpeedIncrease: _increaseSpeed,
                onExit: _exitTeleprompter,
                isVisible: _controlsVisible,
              ),
            ),

            // Emergency Tap Area (invisible overlay)
            if (!_controlsVisible)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _showControls,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
