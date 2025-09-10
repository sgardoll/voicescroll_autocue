import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_slider_widget.dart';
import './widgets/settings_toggle_widget.dart';
import './widgets/voice_test_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Voice Recognition Settings
  double _voiceSensitivity = 0.7;
  String _selectedLanguage = 'English (US)';
  bool _accentAdaptation = true;
  bool _noiseFiltering = true;
  bool _voiceCommands = true;

  // Display Settings
  double _fontSize = 18.0;
  double _contrast = 0.8;
  double _brightness = 0.9;
  bool _orientationLock = false;
  bool _highContrast = false;
  String _fontFamily = 'Inter';

  // Teleprompter Settings
  double _scrollSpeed = 1.5;
  bool _manualOverride = true;
  bool _autoStart = false;
  bool _pauseOnSilence = true;

  // App Preferences
  bool _cloudSync = false;
  String _exportFormat = 'PDF';
  bool _analytics = false;
  bool _crashReporting = true;
  bool _showAdvanced = false;

  final List<Map<String, dynamic>> _languages = [
    {'name': 'English (US)', 'code': 'en-US'},
    {'name': 'English (UK)', 'code': 'en-GB'},
    {'name': 'Spanish', 'code': 'es-ES'},
    {'name': 'French', 'code': 'fr-FR'},
    {'name': 'German', 'code': 'de-DE'},
    {'name': 'Italian', 'code': 'it-IT'},
    {'name': 'Portuguese', 'code': 'pt-PT'},
    {'name': 'Japanese', 'code': 'ja-JP'},
    {'name': 'Korean', 'code': 'ko-KR'},
    {'name': 'Chinese (Simplified)', 'code': 'zh-CN'},
  ];

  final List<String> _fontFamilies = [
    'Inter',
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Source Sans Pro',
  ];

  final List<String> _exportFormats = [
    'PDF',
    'TXT',
    'DOCX',
    'HTML',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Language',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final language = _languages[index];
                  final isSelected = _selectedLanguage == language['name'];

                  return ListTile(
                    title: Text(
                      language['name'] as String,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color:
                            isSelected ? AppTheme.accent : AppTheme.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.accent,
                            size: 5.w,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedLanguage = language['name'] as String;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Font Family',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _fontFamilies.length,
                itemBuilder: (context, index) {
                  final font = _fontFamilies[index];
                  final isSelected = _fontFamily == font;

                  return ListTile(
                    title: Text(
                      font,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color:
                            isSelected ? AppTheme.accent : AppTheme.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.accent,
                            size: 5.w,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _fontFamily = font;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportFormatSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Default Export Format',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _exportFormats.length,
                itemBuilder: (context, index) {
                  final format = _exportFormats[index];
                  final isSelected = _exportFormat == format;

                  return ListTile(
                    title: Text(
                      format,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color:
                            isSelected ? AppTheme.accent : AppTheme.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.accent,
                            size: 5.w,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _exportFormat = format;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondary,
        title: Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          content,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(
              'Reset',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _resetVoiceCalibration() {
    setState(() {
      _voiceSensitivity = 0.7;
      _selectedLanguage = 'English (US)';
      _accentAdaptation = true;
      _noiseFiltering = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice calibration reset successfully')),
    );
  }

  void _resetAllSettings() {
    setState(() {
      _voiceSensitivity = 0.7;
      _selectedLanguage = 'English (US)';
      _accentAdaptation = true;
      _noiseFiltering = true;
      _voiceCommands = true;
      _fontSize = 18.0;
      _contrast = 0.8;
      _brightness = 0.9;
      _orientationLock = false;
      _highContrast = false;
      _fontFamily = 'Inter';
      _scrollSpeed = 1.5;
      _manualOverride = true;
      _autoStart = false;
      _pauseOnSilence = true;
      _cloudSync = false;
      _exportFormat = 'PDF';
      _analytics = false;
      _crashReporting = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All settings reset to defaults')),
    );
  }

  List<Widget> _getFilteredSettings() {
    if (_searchQuery.isEmpty) return _getAllSettings();

    final filteredSettings = <Widget>[];
    final query = _searchQuery.toLowerCase();

    // Voice Recognition Section
    if ('voice recognition sensitivity language accent noise filtering commands'
        .contains(query)) {
      filteredSettings.add(_buildVoiceRecognitionSection());
    }

    // Display Section
    if ('display font size contrast brightness orientation lock high contrast'
        .contains(query)) {
      filteredSettings.add(_buildDisplaySection());
    }

    // Teleprompter Section
    if ('teleprompter scroll speed manual override auto start pause silence'
        .contains(query)) {
      filteredSettings.add(_buildTeleprompterSection());
    }

    // App Preferences Section
    if ('app preferences cloud sync export format analytics crash reporting privacy'
        .contains(query)) {
      filteredSettings.add(_buildAppPreferencesSection());
    }

    return filteredSettings;
  }

  List<Widget> _getAllSettings() {
    return [
      _buildVoiceRecognitionSection(),
      _buildDisplaySection(),
      _buildTeleprompterSection(),
      _buildAppPreferencesSection(),
      if (_showAdvanced) _buildAdvancedSection(),
      _buildResetSection(),
    ];
  }

  Widget _buildVoiceRecognitionSection() {
    return SettingsSectionWidget(
      title: 'VOICE RECOGNITION',
      children: [
        SettingsSliderWidget(
          title: 'Voice Sensitivity',
          subtitle: 'Adjust microphone sensitivity',
          iconName: 'mic',
          value: _voiceSensitivity,
          min: 0.1,
          max: 1.0,
          divisions: 9,
          onChanged: (value) => setState(() => _voiceSensitivity = value),
          valueFormatter: (value) => '\${(value * 100).toInt()}%',
        ),
        SettingsItemWidget(
          title: 'Language',
          subtitle: 'Speech recognition language',
          value: _selectedLanguage,
          iconName: 'language',
          onTap: _showLanguageSelector,
        ),
        SettingsToggleWidget(
          title: 'Accent Adaptation',
          subtitle: 'Improve recognition for your accent',
          iconName: 'record_voice_over',
          value: _accentAdaptation,
          onChanged: (value) => setState(() => _accentAdaptation = value),
        ),
        SettingsToggleWidget(
          title: 'Noise Filtering',
          subtitle: 'Filter background noise',
          iconName: 'noise_control_off',
          value: _noiseFiltering,
          onChanged: (value) => setState(() => _noiseFiltering = value),
        ),
        SettingsToggleWidget(
          title: 'Voice Commands',
          subtitle: 'Enable pause/resume voice commands',
          iconName: 'voice_chat',
          value: _voiceCommands,
          onChanged: (value) => setState(() => _voiceCommands = value),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildDisplaySection() {
    return SettingsSectionWidget(
      title: 'DISPLAY OPTIONS',
      children: [
        SettingsSliderWidget(
          title: 'Font Size',
          subtitle: 'Teleprompter text size',
          iconName: 'format_size',
          value: _fontSize,
          min: 12.0,
          max: 48.0,
          divisions: 18,
          onChanged: (value) => setState(() => _fontSize = value),
          valueFormatter: (value) => '\${value.toInt()}pt',
        ),
        SettingsItemWidget(
          title: 'Font Family',
          subtitle: 'Choose text font',
          value: _fontFamily,
          iconName: 'font_download',
          onTap: _showFontSelector,
        ),
        SettingsSliderWidget(
          title: 'Contrast',
          subtitle: 'Text contrast level',
          iconName: 'contrast',
          value: _contrast,
          min: 0.1,
          max: 1.0,
          divisions: 9,
          onChanged: (value) => setState(() => _contrast = value),
          valueFormatter: (value) => '\${(value * 100).toInt()}%',
        ),
        SettingsSliderWidget(
          title: 'Brightness',
          subtitle: 'Screen brightness',
          iconName: 'brightness_6',
          value: _brightness,
          min: 0.1,
          max: 1.0,
          divisions: 9,
          onChanged: (value) => setState(() => _brightness = value),
          valueFormatter: (value) => '\${(value * 100).toInt()}%',
        ),
        SettingsToggleWidget(
          title: 'Orientation Lock',
          subtitle: 'Lock screen orientation',
          iconName: 'screen_lock_rotation',
          value: _orientationLock,
          onChanged: (value) => setState(() => _orientationLock = value),
        ),
        SettingsToggleWidget(
          title: 'High Contrast Mode',
          subtitle: 'Enhanced contrast for better readability',
          iconName: 'high_quality',
          value: _highContrast,
          onChanged: (value) => setState(() => _highContrast = value),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildTeleprompterSection() {
    return SettingsSectionWidget(
      title: 'TELEPROMPTER CONTROLS',
      children: [
        SettingsSliderWidget(
          title: 'Scroll Speed',
          subtitle: 'Default scrolling speed',
          iconName: 'speed',
          value: _scrollSpeed,
          min: 0.5,
          max: 3.0,
          divisions: 10,
          onChanged: (value) => setState(() => _scrollSpeed = value),
          valueFormatter: (value) => '\${value.toStringAsFixed(1)}x',
        ),
        SettingsToggleWidget(
          title: 'Manual Override',
          subtitle: 'Allow manual scroll control',
          iconName: 'touch_app',
          value: _manualOverride,
          onChanged: (value) => setState(() => _manualOverride = value),
        ),
        SettingsToggleWidget(
          title: 'Auto Start',
          subtitle: 'Start scrolling when speech detected',
          iconName: 'play_circle',
          value: _autoStart,
          onChanged: (value) => setState(() => _autoStart = value),
        ),
        SettingsToggleWidget(
          title: 'Pause on Silence',
          subtitle: 'Pause when no speech detected',
          iconName: 'pause_circle',
          value: _pauseOnSilence,
          onChanged: (value) => setState(() => _pauseOnSilence = value),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildAppPreferencesSection() {
    return SettingsSectionWidget(
      title: 'APP PREFERENCES',
      children: [
        SettingsToggleWidget(
          title: 'Cloud Sync',
          subtitle: 'Sync scripts across devices',
          iconName: 'cloud_sync',
          value: _cloudSync,
          onChanged: (value) => setState(() => _cloudSync = value),
        ),
        SettingsItemWidget(
          title: 'Export Format',
          subtitle: 'Default format for script export',
          value: _exportFormat,
          iconName: 'file_download',
          onTap: _showExportFormatSelector,
        ),
        SettingsToggleWidget(
          title: 'Analytics',
          subtitle: 'Help improve the app',
          iconName: 'analytics',
          value: _analytics,
          onChanged: (value) => setState(() => _analytics = value),
        ),
        SettingsToggleWidget(
          title: 'Crash Reporting',
          subtitle: 'Send crash reports to developers',
          iconName: 'bug_report',
          value: _crashReporting,
          onChanged: (value) => setState(() => _crashReporting = value),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildAdvancedSection() {
    return SettingsSectionWidget(
      title: 'ADVANCED SETTINGS',
      children: [
        const VoiceTestWidget(),
        SizedBox(height: 2.h),
        SettingsItemWidget(
          title: 'Voice Calibration',
          subtitle: 'Recalibrate voice recognition',
          iconName: 'tune',
          onTap: () => Navigator.pushNamed(context, '/voice-calibration'),
        ),
        SettingsItemWidget(
          title: 'Privacy Settings',
          subtitle: 'Manage data and privacy',
          iconName: 'privacy_tip',
          onTap: () {
            // Navigate to privacy settings
          },
        ),
        SettingsItemWidget(
          title: 'Storage Management',
          subtitle: 'Manage app storage and cache',
          iconName: 'storage',
          onTap: () {
            // Navigate to storage management
          },
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildResetSection() {
    return SettingsSectionWidget(
      title: 'RESET OPTIONS',
      children: [
        SettingsItemWidget(
          title: 'Reset Voice Calibration',
          subtitle: 'Reset voice recognition settings',
          iconName: 'refresh',
          iconColor: AppTheme.warning,
          onTap: () => _showResetDialog(
            'Reset Voice Calibration',
            'This will reset all voice recognition settings to their default values.',
            _resetVoiceCalibration,
          ),
        ),
        SettingsItemWidget(
          title: 'Reset All Settings',
          subtitle: 'Reset all app settings to defaults',
          iconName: 'settings_backup_restore',
          iconColor: AppTheme.error,
          onTap: () => _showResetDialog(
            'Reset All Settings',
            'This will reset all settings to their default values. This action cannot be undone.',
            _resetAllSettings,
          ),
        ),
        SettingsItemWidget(
          title: 'Clear Cache',
          subtitle: 'Clear app cache and temporary files',
          iconName: 'clear_all',
          iconColor: AppTheme.textSecondary,
          onTap: () => _showResetDialog(
            'Clear Cache',
            'This will clear all cached data and temporary files.',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
          ),
          showDivider: false,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimary,
            size: 6.w,
          ),
          onPressed: () => Navigator.pushReplacementNamed(context, '/script-library'),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.textPrimary,
              size: 6.w,
            ),
            onPressed: () {
              // Show help dialog
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search settings...',
                hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondary,
                    size: 5.w,
                  ),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: AppTheme.textSecondary,
                          size: 5.w,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 3.h,
                ),
              ),
            ),
          ),

          // Settings Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  // Show Advanced Settings Toggle
                  if (_searchQuery.isEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: SettingsToggleWidget(
                        title: 'Show Advanced Settings',
                        subtitle: 'Show additional configuration options',
                        iconName: 'settings',
                        value: _showAdvanced,
                        onChanged: (value) =>
                            setState(() => _showAdvanced = value),
                        showDivider: false,
                      ),
                    ),

                  // Settings Sections
                  ..._getFilteredSettings(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
