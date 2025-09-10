import 'dart:async';
import 'dart:math' as math;

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
  const TeleprompterView({super.key});

  @override
  State<TeleprompterView> createState() => _TeleprompterViewState();
}

class _TeleprompterViewState extends State<TeleprompterView>
    with TickerProviderStateMixin {
  // Controllers and Animation
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late AnimationController _controlsFadeController;
  late AnimationController _overlayFadeController;
  Timer? _autoHideTimer;
  Timer? _scrollTimer;

  // Speech Recognition
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _currentRecognizedText = '';
  String? _speechError;
  bool _permissionDenied = false;

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
  final Map<String, List<int>> _wordPositionsCache = {};
  Timer? _speechTimeoutTimer;
  DateTime? _lastSpeechTime;
  bool _continuousListening = false;
  int _speechRestartAttempts = 0;
  static const int _maxRestartAttempts = 3;

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

    // Main fade controller for screen entrance
    _fadeController = AnimationController(
      duration:
          const Duration(milliseconds: 1200), // Slower, more intentional fade
      vsync: this,
    );

    // Controls fade controller for smoother UI transitions
    _controlsFadeController = AnimationController(
      duration: const Duration(milliseconds: 600), // Smooth controls fade
      vsync: this,
    );

    // Overlay fade controller for status messages
    _overlayFadeController = AnimationController(
      duration: const Duration(milliseconds: 400), // Quick overlay transitions
      vsync: this,
    );

    _fadeController.forward();
    _controlsFadeController.forward();
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
    _autoHideTimer = Timer(const Duration(seconds: 5), () {
      // Longer delay for laptop/tablet
      if (mounted) {
        _controlsFadeController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _controlsVisible = false;
            });
          }
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
    
    _buildWordPositionsCache();
  }
  
  void _buildWordPositionsCache() {
    _wordPositionsCache.clear();
    for (int i = 0; i < _scriptWords.length; i++) {
      final word = _scriptWords[i];
      if (!_wordPositionsCache.containsKey(word)) {
        _wordPositionsCache[word] = [];
      }
      _wordPositionsCache[word]!.add(i);
    }
    debugPrint('Built word positions cache for ${_wordPositionsCache.length} unique words');
  }
  
  void _startSpeechTimeoutMonitor() {
    _speechTimeoutTimer?.cancel();
    _speechTimeoutTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_continuousListening || !_voiceRecognitionActive) {
        timer.cancel();
        return;
      }
      
      final now = DateTime.now();
      if (_lastSpeechTime != null && 
          now.difference(_lastSpeechTime!).inSeconds > 10) {
        // No speech activity for 10 seconds, check if still listening
        debugPrint('No speech activity detected, checking listening status');
        if (!_speechToText.isListening && _speechRestartAttempts < _maxRestartAttempts) {
          debugPrint('Attempting to restart speech recognition due to timeout');
          _speechRestartAttempts++;
          _restartSpeechRecognition();
        }
      }
    });
  }
  
  void _resetSpeechTimeoutTimer() {
    _startSpeechTimeoutMonitor();
  }
  
  Future<void> _restartSpeechRecognition() async {
    if (!_isPlaying || !_voiceRecognitionActive) return;
    
    debugPrint('Restarting speech recognition (attempt $_speechRestartAttempts/$_maxRestartAttempts)');
    
    try {
      await _speechToText.stop();
      await Future.delayed(const Duration(milliseconds: 200)); // Short delay
      await _startListening();
    } catch (e) {
      debugPrint('Error restarting speech recognition: $e');
      if (_speechRestartAttempts >= _maxRestartAttempts) {
        debugPrint('Max restart attempts reached, disabling voice recognition');
        setState(() {
          _speechError = 'Voice recognition failed. Please restart manually.';
          _voiceRecognitionActive = false;
        });
      }
    }
  }

  Future<void> _initializeSpeechRecognition() async {
    debugPrint('Initializing speech recognition...');

    try {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint('Speech recognition status: $status');
          setState(() {
            _isListening = status == 'listening';
          });
        },
        onError: (errorNotification) {
          debugPrint('Speech recognition error: ${errorNotification.errorMsg}');
          setState(() {
            _speechError = errorNotification.errorMsg;
            _speechEnabled = false;
          });
        },
      );

      debugPrint('Speech recognition available: $available');

      if (available) {
        setState(() {
          _speechEnabled = true;
          _speechError = null;
        });
        debugPrint('Speech recognition enabled successfully');
      } else {
        debugPrint('Speech recognition not available on this device');
        setState(() {
          _speechEnabled = false;
          _speechError = 'Speech recognition not available on this device';
        });
      }
    } catch (e) {
      debugPrint('Error initializing speech recognition: $e');
      setState(() {
        _speechEnabled = false;
        _speechError = 'Failed to initialize speech recognition: $e';
      });
    }
  }

  Future<void> _startListening() async {
    if (!_speechEnabled) {
      await _initializeSpeechRecognition();
      if (!_speechEnabled) {
        debugPrint('Speech recognition not available');
        setState(() {
          _speechError = 'Speech recognition not available on this device';
        });
        _overlayFadeController.forward();
        return;
      }
    }

    try {
      var permissionStatus = await Permission.microphone.request();
      if (permissionStatus.isGranted) {
        debugPrint('Starting speech recognition...');
        setState(() {
          _permissionDenied = false;
          _speechError = null;
        });
        await _speechToText.listen(
          onResult: _onSpeechResult,
          listenFor: const Duration(minutes: 30), // Much longer session
          pauseFor: const Duration(seconds: 3), // Shorter pause for responsiveness
          partialResults: true, // Using deprecated parameter until SpeechListenOptions available
          localeId: 'en_US',
          onSoundLevelChange: (level) {
            // Optional: Handle sound level changes
          },
        );
        
        setState(() {
          _continuousListening = true;
        });
        
        _startSpeechTimeoutMonitor();
      } else {
        debugPrint('Microphone permission denied: $permissionStatus');
        setState(() {
          _permissionDenied = true;
          _speechError =
              'Microphone permission denied. Please enable microphone access in Settings.';
        });
        _overlayFadeController.forward();
      }
    } catch (e) {
      debugPrint('Error starting speech recognition: $e');
      setState(() {
        _speechError = 'Failed to start speech recognition: $e';
      });
    }
  }

  Future<void> _stopListening() async {
    debugPrint('Stopping speech recognition');
    _speechTimeoutTimer?.cancel();
    _continuousListening = false;
    _speechRestartAttempts = 0;
    await _speechToText.stop();
  }

  void _onSpeechResult(result) {
    debugPrint(
        'Speech result: ${result.recognizedWords} (final: ${result.finalResult})');

    _lastSpeechTime = DateTime.now();
    _resetSpeechTimeoutTimer();

    // Only update UI with current text, don't process partials for word matching
    if (mounted) {
      setState(() {
        _currentRecognizedText = result.recognizedWords.toLowerCase();
      });
    }

    // Only process final results for word advancement
    if (result.finalResult) {
      debugPrint('Processing final result: $_currentRecognizedText');
      _processRecognizedText(_currentRecognizedText);
      
      if (mounted) {
        setState(() {
          _currentRecognizedText = '';
        });
      }
      
      // No automatic restart - let continuous session handle it
      _speechRestartAttempts = 0; // Reset restart attempts on successful recognition
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
    if (recognizedWords.isEmpty) return _currentWordIndex;
    
    int bestMatch = _currentWordIndex;
    debugPrint('Looking for matches in: $recognizedWords');
    debugPrint('Current word index: $_currentWordIndex');
    debugPrint(
        'Script words around current: ${_scriptWords.skip(_currentWordIndex).take(5).toList()}');

    // Define search window to limit scope and improve performance
    final searchStart = _currentWordIndex;
    final searchEnd = math.min(_scriptWords.length, _currentWordIndex + 15);
    
    // Find the furthest matching word within the search window
    int furthestMatch = _currentWordIndex;
    
    for (String recognizedWord in recognizedWords) {
      // First try exact match using cache
      final positions = _wordPositionsCache[recognizedWord];
      if (positions != null) {
        for (int position in positions) {
          if (position >= searchStart && position < searchEnd && position > furthestMatch) {
            debugPrint('Found exact match: "$recognizedWord" at index $position');
            furthestMatch = position;
          }
        }
      }
      
      // If no exact match, try fuzzy matching only within a smaller window
      if (furthestMatch == _currentWordIndex) {
        for (int i = searchStart; i < math.min(searchEnd, searchStart + 8); i++) {
          if (_wordsMatchFuzzy(_scriptWords[i], recognizedWord)) {
            debugPrint('Found fuzzy match: "${_scriptWords[i]}" matches "$recognizedWord" at index $i');
            if (i > furthestMatch) {
              furthestMatch = i;
            }
            break; // Stop at first fuzzy match to avoid over-processing
          }
        }
      }
    }
    
    if (furthestMatch > _currentWordIndex) {
      bestMatch = furthestMatch + 1; // Move to next word
    }

    debugPrint('Best match found at index: $bestMatch');
    return bestMatch;
  }

  bool _wordsMatchFuzzy(String scriptWord, String recognizedWord) {
    // Exact match
    if (scriptWord == recognizedWord) return true;

    // Ignore very short words to avoid false positives
    if (recognizedWord.length < 3) return false;
    
    // Contains match (either direction)
    if (scriptWord.contains(recognizedWord) ||
        recognizedWord.contains(scriptWord)) {
      return true;
    }

    // Simple fuzzy matching: allow 1-2 character differences for longer words
    if (recognizedWord.length > 4 && scriptWord.length > 4) {
      return _simpleDistance(scriptWord, recognizedWord) <= 2;
    }
    
    return false;
  }
  
  int _simpleDistance(String s1, String s2) {
    // Simple character difference count (much faster than Levenshtein)
    if ((s1.length - s2.length).abs() > 2) return 999; // Too different
    
    int differences = 0;
    int minLength = math.min(s1.length, s2.length);
    
    for (int i = 0; i < minLength; i++) {
      if (s1[i] != s2[i]) differences++;
      if (differences > 2) return differences; // Early exit
    }
    
    differences += (s1.length - s2.length).abs();
    return differences;
  }


  void _showControls() {
    setState(() {
      _controlsVisible = true;
    });
    _controlsFadeController.forward();
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

  Widget _buildSpeechStatusWidget() {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: _permissionDenied
            ? Colors.orange.withValues(alpha: 0.9)
            : Colors.red.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8.0,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                _permissionDenied ? Icons.mic_off : Icons.error_outline,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  _permissionDenied
                      ? 'Microphone Permission Required'
                      : 'Speech Recognition Error',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _speechError = null;
                    _permissionDenied = false;
                  });
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            _speechError ??
                'Please enable microphone access in Settings to use voice recognition.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          if (_permissionDenied) ...[
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () async {
                await openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
              ),
              child: Text(
                'Open Settings',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _controlsFadeController.dispose();
    _overlayFadeController.dispose();
    _autoHideTimer?.cancel();
    _scrollTimer?.cancel();
    _speechTimeoutTimer?.cancel();
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
            FadeTransition(
              opacity: _fadeController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _fadeController,
                  curve: Curves.easeOutQuart,
                )),
                child: GestureDetector(
                  onScaleUpdate: _handleFontSizeChange,
                  child: TeleprompterTextWidget(
                    text: _scriptText,
                    currentWordIndex: _currentWordIndex,
                    fontSize: _fontSize,
                    scrollController: _scrollController,
                    onTap: _handleTextTap,
                  ),
                ),
              ),
            ),

            // Progress Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _controlsFadeController,
                child: TeleprompterProgressWidget(
                  progress: _progress,
                  isVisible: _controlsVisible,
                ),
              ),
            ),

            // Voice Command Indicator
            Positioned(
              top: 4.h,
              right: 4.w,
              child: FadeTransition(
                opacity: _overlayFadeController,
                child: VoiceCommandIndicatorWidget(
                  isListening: _isListening,
                  lastCommand: _lastVoiceCommand,
                  isVisible: _controlsVisible || _isListening,
                ),
              ),
            ),

            // Speech Recognition Status
            if (_speechError != null || _permissionDenied)
              Positioned(
                top: 12.h,
                left: 4.w,
                right: 4.w,
                child: FadeTransition(
                  opacity: _overlayFadeController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.5),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _overlayFadeController,
                      curve: Curves.easeOutBack,
                    )),
                    child: _buildSpeechStatusWidget(),
                  ),
                ),
              ),

            // Bottom Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _controlsFadeController,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _controlsFadeController,
                    curve: Curves.easeOutCubic,
                  )),
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
