# VoiceScroll Autocue

A sophisticated Flutter-based teleprompter application with advanced voice recognition capabilities for hands-free control. Perfect for content creators, presenters, and anyone who needs a professional teleprompter solution.

## Features

### 🎤 Voice Recognition & Control
- **Real-time Speech Recognition**: Control playback, speed, and navigation using voice commands
- **Voice Calibration**: Built-in calibration system to optimize speech recognition for your voice
- **Multiple Platform Support**: Cross-platform speech recognition for Android and iOS
- **Voice-to-Text Recording**: Import scripts by dictating them directly

### 📝 Script Management
- **Multiple Import Methods**: 
  - Manual text editor
  - File picker (text files)
  - Voice-to-text recording
  - Camera scanner for text recognition
  - Cloud storage integration
- **Script Library**: Organize and manage your scripts with search and filtering
- **Text Preview & Editing**: Edit imported text before using in teleprompter

### 📺 Advanced Teleprompter
- **Smooth Scrolling**: Professional-grade text scrolling with customizable speed
- **Responsive Design**: Optimized for all screen sizes and orientations
- **Progress Tracking**: Visual progress indicator showing current position
- **Font Customization**: Adjustable text size for optimal readability
- **Auto-hide Controls**: Distraction-free reading mode with gesture-based controls

### ⚙️ Comprehensive Settings
- **Voice Settings**: Microphone sensitivity, speech recognition parameters
- **Display Settings**: Font size, scroll speed, theme preferences
- **Permissions Management**: Streamlined permission requests for microphone and storage

## Technology Stack

- **Framework**: Flutter 3.6.0+
- **Language**: Dart
- **UI Library**: Material Design with custom theming
- **State Management**: StatefulWidget pattern
- **Speech Recognition**: `speech_to_text` package
- **Audio Recording**: `record` package  
- **File Handling**: `file_picker`, `path_provider`
- **Image Processing**: `camera`, `image_picker`
- **Responsive Design**: `sizer` package
- **Platform Integration**: `permission_handler`

## Getting Started

### Prerequisites

- Flutter SDK 3.6.0 or higher
- Dart SDK compatible with Flutter version
- Android Studio / Xcode for platform-specific development
- Physical device recommended for voice recognition testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sgardoll/voicescroll_autocue.git
   cd voicescroll_autocue
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Platform Setup**
   
   **Android**: 
   - Ensure microphone permissions are configured in `android/app/src/main/AndroidManifest.xml`
   - Minimum SDK version: Check `android/app/build.gradle`
   
   **iOS**:
   - Microphone and speech recognition permissions configured in `ios/Runner/Info.plist`
   - Ensure iOS deployment target meets requirements

4. **Run the application**
   ```bash
   flutter run
   ```

### Development Setup

1. **Enable developer options**
   ```bash
   flutter run --debug
   ```

2. **Run tests** (if available)
   ```bash
   flutter test
   ```

3. **Build for production**
   ```bash
   flutter build apk  # Android
   flutter build ios  # iOS
   ```

## Application Architecture

### Directory Structure

```
voicescroll_autocue/
├── android/                 # Android-specific configuration
├── ios/                     # iOS-specific configuration
├── lib/
│   ├── core/               # Core application utilities
│   ├── presentation/       # UI screens and widgets
│   │   ├── splash_screen/  # App initialization
│   │   ├── script_import/  # Script import functionality
│   │   ├── script_library/ # Script management
│   │   ├── teleprompter_view/ # Main teleprompter interface
│   │   ├── voice_calibration/ # Voice setup and calibration
│   │   └── settings/       # App configuration
│   ├── routes/             # Navigation configuration
│   ├── theme/              # UI theming and styling
│   ├── widgets/            # Reusable UI components
│   └── main.dart           # Application entry point
├── assets/                 # Static assets (images, icons)
├── pubspec.yaml            # Project dependencies and configuration
└── README.md               # Project documentation
```

### Key Components

- **TeleprompterView**: Main reading interface with voice control
- **VoiceCalibration**: Speech recognition setup and testing
- **ScriptImport**: Multi-method script importing system  
- **ScriptLibrary**: Script organization and management
- **Settings**: Comprehensive app configuration

## Permissions

The app requires the following permissions:

### Android
- `RECORD_AUDIO`: Voice recognition and recording
- `MICROPHONE`: Access to device microphone
- `INTERNET`: Network connectivity for cloud features
- `ACCESS_NETWORK_STATE`: Network status monitoring

### iOS
- `NSMicrophoneUsageDescription`: Voice recording and recognition
- `NSSpeechRecognitionUsageDescription`: Speech-to-text functionality

## Usage

### Basic Operation

1. **First Launch**: Complete voice calibration to optimize speech recognition
2. **Import Script**: Choose from multiple import methods in the script library
3. **Configure Settings**: Adjust voice sensitivity, text size, and scroll speed
4. **Start Teleprompter**: Use voice commands or manual controls to operate

### Voice Commands

The application supports various voice commands for hands-free operation:
- Start/Stop playback
- Speed control
- Navigation commands
- (Specific commands depend on implementation details)

## Configuration

### Environment Setup

- Check `env.json` for environment-specific configurations
- Modify `pubspec.yaml` for dependency management
- Platform configurations in respective `android/` and `ios/` directories

### Customization

The app follows a modular architecture allowing for easy customization:
- Themes in `lib/theme/app_theme.dart`
- Routes in `lib/routes/app_routes.dart`
- Core utilities in `lib/core/app_export.dart`

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart style conventions
- Maintain responsive design principles
- Test voice recognition functionality on physical devices
- Ensure cross-platform compatibility
- Update documentation for new features

## Troubleshooting

### Common Issues

**Voice Recognition Not Working**:
- Ensure microphone permissions are granted
- Test microphone functionality in device settings
- Run voice calibration process
- Check network connectivity for speech services

**Build Errors**:
- Run `flutter clean && flutter pub get`
- Verify Flutter SDK version compatibility
- Check platform-specific configurations

**Performance Issues**:
- Test on physical device rather than emulator
- Check memory usage with large scripts
- Optimize scroll performance settings

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For issues, questions, or feature requests:
- Open an issue on GitHub
- Check existing documentation
- Review troubleshooting section

## Acknowledgments

- Flutter team for the excellent framework
- Speech recognition library contributors
- Material Design for UI guidelines
- Community contributors and testers

---

**Version**: 1.0.0+1  
**Last Updated**: January 2025  
**Minimum Flutter Version**: 3.6.0
