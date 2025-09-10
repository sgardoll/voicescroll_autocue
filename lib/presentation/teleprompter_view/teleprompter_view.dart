import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // Speech Recognition
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _currentRecognizedText = '';

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
  List<String> _scriptWords = [];
  int _lastMatchedWordIndex = -1;

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
    _initializeSpeechRecognition();
    _initializeScriptWords();
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

  void _initializeScriptWords() {
    _scriptWords = _scriptText
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
  }

  Future<void> _initializeSpeechRecognition() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        setState(() {
          _isListening = status == 'listening';
        });
      },
      onError: (errorNotification) {
        debugPrint('Speech recognition error: ${errorNotification.errorMsg}');
      },
    );

    if (available) {
      setState(() {
        _speechEnabled = true;
      });
    }
  }

  Future<void> _startListening() async {
    if (!_speechEnabled) {
      await _initializeSpeechRecognition();
      return;
    }

    if (await Permission.microphone.request().isGranted) {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'en_US',
        onSoundLevelChange: (level) {
          // Optional: Handle sound level changes
        },
      );
    }
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(result) {
    setState(() {
      _currentRecognizedText = result.recognizedWords.toLowerCase();
    });

    if (result.finalResult) {
      _processRecognizedText(_currentRecognizedText);
      _currentRecognizedText = '';
    }
  }

  void _processRecognizedText(String recognizedText) {
    if (!_isPlaying || !_voiceRecognitionActive) return;

    final recognizedWords = recognizedText
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (recognizedWords.isEmpty) return;

    // Find matching words in the script
    int newWordIndex = _findMatchingWords(recognizedWords);

    if (newWordIndex > _lastMatchedWordIndex) {
      setState(() {
        _currentWordIndex = newWordIndex;
        _progress = _currentWordIndex / _scriptWords.length;
        _lastMatchedWordIndex = newWordIndex;
      });

      _autoScrollToCurrentWord();

      // Show listening indicator briefly
      setState(() {
        _isListening = true;
      });

      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
        }
      });
    }
  }

  int _findMatchingWords(List<String> recognizedWords) {
    int bestMatch = _currentWordIndex;

    // Look for matches starting from current position
    for (int i = _currentWordIndex; i < _scriptWords.length; i++) {
      for (String recognizedWord in recognizedWords) {
        if (_scriptWords[i].contains(recognizedWord) ||
            recognizedWord.contains(_scriptWords[i])) {
          bestMatch = i;
          break;
        }
      }
    }

    return bestMatch;
  }

  void _showControls() {
    setState(() {
      _controlsVisible = true;
    });
    _startAutoHideTimer();
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

  void _togglePlayPause() async {
    setState(() {
      _isPlaying = !_isPlaying;
      _voiceRecognitionActive = _isPlaying;
    });

    if (_isPlaying) {
      await _startListening();
    } else {
      await _stopListening();
    }

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
    _speechToText.stop();
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
            Positioned(
              top: 4.h,
              right: 4.w,
              child: VoiceCommandIndicatorWidget(
                isListening: _isListening,
                lastCommand: _lastVoiceCommand,
                isVisible: _controlsVisible || _isListening,
              ),
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
