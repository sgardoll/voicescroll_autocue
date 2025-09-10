import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/offline_mode_widget.dart';
import './widgets/permission_modal_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _loadingProgress = 0.0;
  String _loadingText = 'Initializing VoiceScroll Autocue...';
  bool _showPermissionModal = false;
  bool _showOfflineModal = false;
  bool _isInitializing = true;

  final List<Map<String, dynamic>> _initializationSteps = [
    {
      'text': 'Initializing VoiceScroll Autocue...',
      'duration': 800,
      'progress': 0.2,
    },
    {
      'text': 'Loading speech recognition models...',
      'duration': 1000,
      'progress': 0.5,
    },
    {
      'text': 'Checking cached scripts...',
      'duration': 600,
      'progress': 0.7,
    },
    {
      'text': 'Preparing voice calibration...',
      'duration': 800,
      'progress': 0.9,
    },
    {
      'text': 'Ready to launch!',
      'duration': 400,
      'progress': 1.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _hideSystemUI();
    _startInitialization();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }

  Future<void> _startInitialization() async {
    try {
      // Execute initialization steps with progress updates
      for (int i = 0; i < _initializationSteps.length; i++) {
        final step = _initializationSteps[i];

        setState(() {
          _loadingText = step['text'] as String;
          _loadingProgress = step['progress'] as double;
        });

        await Future.delayed(Duration(milliseconds: step['duration'] as int));

        // Check microphone permission during speech recognition step
        if (i == 1) {
          final hasPermission = await _checkMicrophonePermission();
          if (!hasPermission) {
            setState(() {
              _isInitializing = false;
              _showPermissionModal = true;
            });
            return;
          }
        }

        // Check speech recognition availability during model loading
        if (i == 1) {
          final isAvailable = await _checkSpeechRecognitionAvailability();
          if (!isAvailable) {
            setState(() {
              _isInitializing = false;
              _showOfflineModal = true;
            });
            return;
          }
        }
      }

      // Complete initialization
      await _completeInitialization();
    } catch (e) {
      // Handle initialization errors gracefully
      setState(() {
        _isInitializing = false;
        _showOfflineModal = true;
      });
    }
  }

  Future<bool> _checkMicrophonePermission() async {
    try {
      final status = await Permission.microphone.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _checkSpeechRecognitionAvailability() async {
    try {
      // Simulate speech recognition availability check
      await Future.delayed(const Duration(milliseconds: 500));
      // In a real implementation, this would check if speech recognition services are available
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _requestMicrophonePermission() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        setState(() {
          _showPermissionModal = false;
          _isInitializing = true;
          _loadingProgress = 0.5;
          _loadingText = 'Loading speech recognition models...';
        });
        await _continueInitialization();
      } else {
        _navigateToOfflineMode();
      }
    } catch (e) {
      _navigateToOfflineMode();
    }
  }

  Future<void> _continueInitialization() async {
    // Continue from speech recognition step
    for (int i = 2; i < _initializationSteps.length; i++) {
      final step = _initializationSteps[i];

      setState(() {
        _loadingText = step['text'] as String;
        _loadingProgress = step['progress'] as double;
      });

      await Future.delayed(Duration(milliseconds: step['duration'] as int));
    }

    await _completeInitialization();
  }

  Future<void> _completeInitialization() async {
    _restoreSystemUI();

    // Check if user has existing scripts
    final hasExistingScripts = await _checkExistingScripts();

    // Navigate based on user state
    if (hasExistingScripts) {
      Navigator.pushReplacementNamed(context, '/script-library');
    } else {
      Navigator.pushReplacementNamed(context, '/script-import');
    }
  }

  Future<bool> _checkExistingScripts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scripts = prefs.getStringList('cached_scripts') ?? [];
      return scripts.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void _navigateToOfflineMode() {
    _restoreSystemUI();
    Navigator.pushReplacementNamed(context, '/script-library');
  }

  void _handlePermissionDeny() {
    setState(() {
      _showPermissionModal = false;
      _showOfflineModal = true;
    });
  }

  void _handleOfflineRetry() {
    setState(() {
      _showOfflineModal = false;
      _isInitializing = true;
      _loadingProgress = 0.0;
      _loadingText = 'Initializing VoiceScroll Autocue...';
    });
    _startInitialization();
  }

  void _handleOfflineContinue() {
    _navigateToOfflineMode();
  }

  @override
  void dispose() {
    _restoreSystemUI();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.surface,
              AppTheme.primary.withValues(alpha: 0.8),
              AppTheme.surface,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Animated logo
                  const AnimatedLogoWidget(),

                  SizedBox(height: 4.h),

                  // App name
                  Text(
                    'VoiceScroll Autocue',
                    style:
                        AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 6.w,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 1.h),

                  // Tagline
                  Text(
                    'Professional Teleprompter with Voice Recognition',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                      fontSize: 3.2.w,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 1),

                  // Loading indicator
                  if (_isInitializing)
                    LoadingIndicatorWidget(
                      loadingText: _loadingText,
                      progress: _loadingProgress,
                    ),

                  const Spacer(flex: 2),
                ],
              ),

              // Permission modal
              if (_showPermissionModal)
                Container(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Center(
                    child: PermissionModalWidget(
                      onAllowPressed: _requestMicrophonePermission,
                      onDenyPressed: _handlePermissionDeny,
                    ),
                  ),
                ),

              // Offline mode modal
              if (_showOfflineModal)
                Container(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Center(
                    child: OfflineModeWidget(
                      onContinuePressed: _handleOfflineContinue,
                      onRetryPressed: _handleOfflineRetry,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
