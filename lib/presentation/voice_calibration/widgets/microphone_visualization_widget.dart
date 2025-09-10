import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MicrophoneVisualizationWidget extends StatefulWidget {
  final bool isListening;
  final double audioLevel;
  final double recognitionConfidence;

  const MicrophoneVisualizationWidget({
    Key? key,
    required this.isListening,
    required this.audioLevel,
    required this.recognitionConfidence,
  }) : super(key: key);

  @override
  State<MicrophoneVisualizationWidget> createState() =>
      _MicrophoneVisualizationWidgetState();
}

class _MicrophoneVisualizationWidgetState
    extends State<MicrophoneVisualizationWidget> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _levelController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _levelAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _levelController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _levelAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _levelController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(MicrophoneVisualizationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }

    if (widget.audioLevel != oldWidget.audioLevel) {
      _levelController.animateTo(widget.audioLevel);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  Color _getConfidenceColor() {
    if (widget.recognitionConfidence >= 0.8) {
      return AppTheme.success;
    } else if (widget.recognitionConfidence >= 0.6) {
      return AppTheme.warning;
    } else {
      return AppTheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer confidence ring
          AnimatedBuilder(
            animation: _levelAnimation,
            builder: (context, child) {
              return Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getConfidenceColor().withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: CircularProgressIndicator(
                  value: widget.recognitionConfidence,
                  strokeWidth: 3,
                  backgroundColor: AppTheme.border,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_getConfidenceColor()),
                ),
              );
            },
          ),

          // Audio level rings
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _levelAnimation,
              builder: (context, child) {
                final scale =
                    0.6 + (index * 0.15) + (_levelAnimation.value * 0.3);
                final opacity = widget.isListening ? (0.3 - index * 0.1) : 0.0;

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.accent.withValues(alpha: opacity),
                        width: 1,
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Main microphone icon
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isListening ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isListening
                        ? AppTheme.accent
                        : AppTheme.secondary,
                    boxShadow: widget.isListening
                        ? [
                            BoxShadow(
                              color: AppTheme.accent.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : null,
                  ),
                  child: CustomIconWidget(
                    iconName: 'mic',
                    color: AppTheme.textPrimary,
                    size: 8.w,
                  ),
                ),
              );
            },
          ),

          // Status indicator
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getConfidenceColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.isListening ? 'Listening...' : 'Ready',
                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
