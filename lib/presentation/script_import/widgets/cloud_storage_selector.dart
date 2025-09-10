import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CloudStorageSelector extends StatefulWidget {
  final Function(String) onFileSelected;
  final VoidCallback onClose;

  const CloudStorageSelector({
    Key? key,
    required this.onFileSelected,
    required this.onClose,
  }) : super(key: key);

  @override
  State<CloudStorageSelector> createState() => _CloudStorageSelectorState();
}

class _CloudStorageSelectorState extends State<CloudStorageSelector> {
  bool _isConnecting = false;
  String? _selectedService;

  final List<Map<String, dynamic>> _cloudServices = [
    {
      'id': 'google_drive',
      'name': 'Google Drive',
      'icon': 'cloud',
      'color': Color(0xFF4285F4),
      'description': 'Access documents from Google Drive',
    },
    {
      'id': 'dropbox',
      'name': 'Dropbox',
      'icon': 'cloud_upload',
      'color': Color(0xFF0061FF),
      'description': 'Import files from Dropbox',
    },
    {
      'id': 'icloud',
      'name': 'iCloud Drive',
      'icon': 'cloud_download',
      'color': Color(0xFF007AFF),
      'description': 'Connect to iCloud storage',
    },
    {
      'id': 'onedrive',
      'name': 'OneDrive',
      'icon': 'cloud_sync',
      'color': Color(0xFF0078D4),
      'description': 'Access Microsoft OneDrive files',
    },
  ];

  Future<void> _connectToService(String serviceId, String serviceName) async {
    setState(() {
      _isConnecting = true;
      _selectedService = serviceName;
    });

    try {
      // Simulate authentication and file selection
      await Future.delayed(Duration(seconds: 2));

      // Mock successful connection and file retrieval
      String mockContent = _getMockContentForService(serviceId);
      widget.onFileSelected(mockContent);
    } catch (e) {
      _showErrorMessage('Failed to connect to $serviceName. Please try again.');
    } finally {
      setState(() {
        _isConnecting = false;
        _selectedService = null;
      });
    }
  }

  String _getMockContentForService(String serviceId) {
    switch (serviceId) {
      case 'google_drive':
        return """Marketing Presentation Script - Google Drive

Welcome to our quarterly marketing review. Today we'll be discussing our achievements, challenges, and strategic direction for the upcoming quarter.

Q3 Performance Highlights:
• 35% increase in brand awareness
• 28% growth in digital engagement
• 42% improvement in conversion rates
• 15% expansion in market reach

Our integrated marketing approach has proven highly effective, combining traditional media with digital innovation to create compelling customer experiences.

Key Initiatives for Q4:
1. Launch of new product line campaign
2. Enhanced social media strategy
3. Partnership development program
4. Customer retention optimization

The data shows strong momentum across all channels, positioning us well for continued growth and market expansion in the coming months.

Thank you for your attention. Let's move to the Q&A session.""";

      case 'dropbox':
        return """Training Module: Public Speaking Excellence - Dropbox

Module 1: Foundation Skills

Effective public speaking begins with understanding your audience and crafting a message that resonates with their needs and interests.

Core Principles:
• Clarity of message and purpose
• Audience engagement techniques
• Confident body language
• Voice modulation and pacing
• Strategic use of pauses

Module 2: Technology Integration

Modern presentation tools enhance delivery effectiveness. Teleprompter applications like VoiceScroll Autocue enable natural, conversational presentation while maintaining audience connection.

Best Practices:
• Practice with teleprompter technology
• Maintain natural eye contact patterns
• Use voice commands for hands-free operation
• Adjust scrolling speed to match natural pace

Module 3: Advanced Techniques

Professional speakers leverage advanced techniques to create memorable, impactful presentations that inspire action and drive results.

Remember: Great speakers are made, not born. Consistent practice and the right tools will elevate your presentation skills to professional levels.""";

      case 'icloud':
        return """Executive Brief: Digital Transformation - iCloud

Executive Summary:
Our organization stands at a pivotal moment in digital transformation. The integration of advanced technologies, including AI-powered presentation tools, positions us for significant competitive advantage.

Strategic Objectives:
• Modernize communication infrastructure
• Enhance employee productivity tools
• Improve customer engagement platforms
• Streamline operational processes

Technology Adoption:
The implementation of voice-controlled teleprompter systems represents our commitment to innovation. These tools reduce presentation preparation time by 60% while improving delivery quality.

Investment Priorities:
1. Advanced communication platforms
2. AI-powered productivity tools
3. Enhanced collaboration systems
4. Professional development programs

Expected Outcomes:
• 40% improvement in presentation effectiveness
• 25% reduction in preparation time
• 50% increase in audience engagement
• 30% enhancement in message retention

This strategic initiative will position our organization as a leader in digital communication excellence.""";

      case 'onedrive':
        return """Project Status Report - OneDrive

Project: VoiceScroll Autocue Implementation
Status: On Track
Completion: 85%

Phase 1: Requirements Analysis ✓
• Stakeholder interviews completed
• Technical specifications finalized
• User experience requirements defined
• Performance benchmarks established

Phase 2: Development & Testing ✓
• Core functionality implemented
• Voice recognition integration completed
• User interface optimization finished
• Cross-platform compatibility verified

Phase 3: Deployment (Current)
• Beta testing with select user groups
• Performance optimization ongoing
• Documentation and training materials
• Final security and compliance review

Next Steps:
1. Complete beta testing feedback integration
2. Finalize deployment procedures
3. Conduct staff training sessions
4. Launch production environment

Risk Assessment: Low
Budget Status: Within allocated resources
Timeline: On schedule for Q4 delivery

The project continues to meet all success criteria and stakeholder expectations.""";

      default:
        return 'Sample content from cloud storage service.';
    }
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
    return Container(
      height: 70.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.secondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),

          // Header
          Row(
            children: [
              IconButton(
                onPressed: widget.onClose,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.textPrimary,
                  size: 6.w,
                ),
              ),
              Expanded(
                child: Text(
                  'Cloud Storage',
                  style: AppTheme.darkTheme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 12.w),
            ],
          ),
          SizedBox(height: 4.h),

          // Content
          Expanded(
            child: _isConnecting
                ? _buildConnectingView()
                : _buildServiceSelection(),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.accent,
            strokeWidth: 3,
          ),
          SizedBox(height: 3.h),
          Text(
            'Connecting to $_selectedService...',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Please wait while we authenticate and retrieve your files',
            style: AppTheme.darkTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelection() {
    return Column(
      children: [
        // Info section
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.accent.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.accent,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Your cloud storage credentials are securely handled and never stored on our servers.',
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),

        // Cloud services list
        Expanded(
          child: ListView.builder(
            itemCount: _cloudServices.length,
            itemBuilder: (context, index) {
              final service = _cloudServices[index];
              return _buildServiceOption(service);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceOption(Map<String, dynamic> service) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _connectToService(service['id'], service['name']),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.darkTheme.colorScheme.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.border.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: (service['color'] as Color).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: service['icon'],
                      color: service['color'],
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['name'],
                        style: AppTheme.darkTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        service['description'],
                        style: AppTheme.darkTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
