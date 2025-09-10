import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraScanner extends StatefulWidget {
  final Function(String) onTextRecognized;
  final VoidCallback onClose;

  const CameraScanner({
    Key? key,
    required this.onTextRecognized,
    required this.onClose,
  }) : super(key: key);

  @override
  State<CameraScanner> createState() => _CameraScannerState();
}

class _CameraScannerState extends State<CameraScanner> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isProcessing = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint('Focus mode error: $e');
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        debugPrint('Flash mode error: $e');
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
      });

      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = photo;
      });

      // Simulate OCR processing
      await Future.delayed(Duration(seconds: 2));

      // Mock OCR result
      const mockText = """Welcome to VoiceScroll Autocue

This is a sample document that has been scanned and processed using optical character recognition technology. The text you see here demonstrates how the camera scanning feature can convert physical documents into digital text format.

Key features of our teleprompter application:
• Real-time speech recognition
• Automatic text scrolling
• Voice command controls
• Multiple import methods
• Professional presentation tools

You can now edit this text or save it directly to your script library for use in your teleprompter sessions.""";

      widget.onTextRecognized(mockText);
    } catch (e) {
      debugPrint('Capture error: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      body: Stack(
        children: [
          // Camera preview
          if (_isInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            Container(
              color: AppTheme.darkTheme.colorScheme.surface,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppTheme.accent,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Initializing camera...',
                      style: AppTheme.darkTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

          // Document detection overlay
          if (_isInitialized)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.accent.withValues(alpha: 0.8),
                    width: 2,
                  ),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 20.h,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.accent.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),

          // Top controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 2.h,
            left: 4.w,
            right: 4.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  color: AppTheme.darkTheme.colorScheme.surface
                      .withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: widget.onClose,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.textPrimary,
                        size: 6.w,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.darkTheme.colorScheme.surface
                        .withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Position document in frame',
                    style: AppTheme.darkTheme.textTheme.bodySmall,
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ),

          // Processing overlay
          if (_isProcessing)
            Positioned.fill(
              child: Container(
                color: AppTheme.darkTheme.colorScheme.surface
                    .withValues(alpha: 0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.accent,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Recognizing text...',
                        style: AppTheme.darkTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Please wait while we process your document',
                        style: AppTheme.darkTheme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom capture button
          if (_isInitialized && !_isProcessing)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 4.h,
              left: 0,
              right: 0,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _capturePhoto,
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.textPrimary,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'camera_alt',
                          color: AppTheme.textPrimary,
                          size: 8.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
