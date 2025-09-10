import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/script_import/script_import.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/script_library/script_library.dart';
import '../presentation/teleprompter_view/teleprompter_view.dart';
import '../presentation/voice_calibration/voice_calibration.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String settings = '/settings';
  static const String scriptImport = '/script-import';
  static const String splash = '/splash-screen';
  static const String scriptLibrary = '/script-library';
  static const String teleprompterView = '/teleprompter-view';
  static const String voiceCalibration = '/voice-calibration';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    settings: (context) => const Settings(),
    scriptImport: (context) => const ScriptImport(),
    splash: (context) => const SplashScreen(),
    scriptLibrary: (context) => const ScriptLibrary(),
    teleprompterView: (context) => const TeleprompterView(),
    voiceCalibration: (context) => const VoiceCalibration(),
    // TODO: Add your other routes here
  };
}
