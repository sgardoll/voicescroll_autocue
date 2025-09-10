import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/import_options_bottom_sheet_widget.dart';
import './widgets/script_card_widget.dart';
import './widgets/search_bar_widget.dart';

class ScriptLibrary extends StatefulWidget {
  const ScriptLibrary({super.key});

  @override
  State<ScriptLibrary> createState() => _ScriptLibraryState();
}

class _ScriptLibraryState extends State<ScriptLibrary>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  SortOption _currentSort = SortOption.recent;
  bool _isGridView = false;
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _filteredScripts = [];

  // Mock data for scripts
  final List<Map<String, dynamic>> _allScripts = [
    {
      "id": 1,
      "title": "Product Launch Presentation",
      "preview":
          "Welcome everyone to today's exciting product launch. We're thrilled to introduce our revolutionary new teleprompter application that will transform how you deliver presentations.",
      "wordCount": 1250,
      "lastModified": "2025-01-09T14:30:00Z",
      "isOffline": false,
      "content": "Full script content here...",
      "createdDate": "2025-01-05T09:00:00Z",
    },
    {
      "id": 2,
      "title": "Weekly Team Meeting Script",
      "preview":
          "Good morning team! Let's start with our weekly progress review. First, I'd like to highlight the achievements from last week and discuss our upcoming milestones.",
      "wordCount": 850,
      "lastModified": "2025-01-08T16:45:00Z",
      "isOffline": true,
      "content": "Full script content here...",
      "createdDate": "2025-01-03T11:30:00Z",
    },
    {
      "id": 3,
      "title": "Conference Keynote Speech",
      "preview":
          "Distinguished guests, fellow innovators, and technology enthusiasts. Today marks a pivotal moment in our industry's evolution as we explore the future of voice-controlled applications.",
      "wordCount": 2100,
      "lastModified": "2025-01-07T10:15:00Z",
      "isOffline": false,
      "content": "Full script content here...",
      "createdDate": "2025-01-01T14:20:00Z",
    },
    {
      "id": 4,
      "title": "Sales Pitch Demo",
      "preview":
          "Thank you for taking the time to meet with us today. I'm excited to show you how our solution can streamline your workflow and increase productivity by up to 40%.",
      "wordCount": 675,
      "lastModified": "2025-01-06T13:20:00Z",
      "isOffline": false,
      "content": "Full script content here...",
      "createdDate": "2024-12-28T16:45:00Z",
    },
    {
      "id": 5,
      "title": "Training Session Introduction",
      "preview":
          "Welcome to our comprehensive training program. Over the next few hours, we'll cover everything you need to know about using voice recognition technology effectively.",
      "wordCount": 1450,
      "lastModified": "2025-01-05T11:30:00Z",
      "isOffline": true,
      "content": "Full script content here...",
      "createdDate": "2024-12-25T09:15:00Z",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredScripts = List.from(_allScripts);
    _sortScripts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.border,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Library'),
                  Tab(text: 'Settings'),
                  Tab(text: 'Help'),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLibraryTab(),
                  _buildSettingsTab(),
                  _buildHelpTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _showImportOptions,
              backgroundColor: AppTheme.accent,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.textPrimary,
                size: 24,
              ),
            )
          : null,
    );
  }

  Widget _buildLibraryTab() {
    return Column(
      children: [
        // Search Bar
        SearchBarWidget(
          onSearchChanged: _handleSearchChanged,
          onVoiceSearch: _handleVoiceSearch,
          onFilterTap: _showFilterOptions,
        ),

        // Scripts List
        Expanded(
          child: _filteredScripts.isEmpty && _searchQuery.isEmpty
              ? EmptyStateWidget(onImportTap: _showImportOptions)
              : _filteredScripts.isEmpty
                  ? _buildNoResultsWidget()
                  : RefreshIndicator(
                      onRefresh: _handleRefresh,
                      color: AppTheme.accent,
                      backgroundColor: AppTheme.secondary,
                      child: _isGridView ? _buildGridView() : _buildListView(),
                    ),
        ),
      ],
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: _filteredScripts.length,
      itemBuilder: (context, index) {
        final script = _filteredScripts[index];
        return ScriptCardWidget(
          script: script,
          onTap: () => _navigateToTeleprompter(script),
          onEdit: () => _handleEdit(script),
          onDuplicate: () => _handleDuplicate(script),
          onShare: () => _handleShare(script),
          onDelete: () => _handleDelete(script),
          onRename: () => _handleRename(script),
          onMoveToFolder: () => _handleMoveToFolder(script),
          onExport: () => _handleExport(script),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.all(4.w).copyWith(bottom: 10.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredScripts.length,
      itemBuilder: (context, index) {
        final script = _filteredScripts[index];
        return ScriptCardWidget(
          script: script,
          onTap: () => _navigateToTeleprompter(script),
          onEdit: () => _handleEdit(script),
          onDuplicate: () => _handleDuplicate(script),
          onShare: () => _handleShare(script),
          onDelete: () => _handleDelete(script),
          onRename: () => _handleRename(script),
          onMoveToFolder: () => _handleMoveToFolder(script),
          onExport: () => _handleExport(script),
        );
      },
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.textSecondary,
              size: 60,
            ),
            SizedBox(height: 2.h),
            Text(
              'No scripts found',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search terms or filters',
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.textSecondary,
              size: 60,
            ),
            SizedBox(height: 2.h),
            Text(
              'Settings',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Configure your teleprompter preferences',
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpTab() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.textSecondary,
              size: 60,
            ),
            SizedBox(height: 2.h),
            Text(
              'Help & Support',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Get help with using VoiceScroll Autocue',
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Column(
              children: [
                _buildHelpOption('Getting Started Guide', 'book'),
                _buildHelpOption('Voice Commands', 'mic'),
                _buildHelpOption('Troubleshooting', 'build'),
                _buildHelpOption('Contact Support', 'support_agent'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpOption(String title, String iconName) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: iconName,
          color: AppTheme.accent,
          size: 24,
        ),
        title: Text(
          title,
          style: AppTheme.darkTheme.textTheme.bodyLarge,
        ),
        trailing: CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: AppTheme.textSecondary,
          size: 16,
        ),
        onTap: () {
          Fluttertoast.showToast(
            msg: 'Opening $title',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
      ),
    );
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterScripts();
    });
  }

  void _handleVoiceSearch() {
    Fluttertoast.showToast(
      msg: 'Voice search activated',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheetWidget(
        currentSort: _currentSort,
        isGridView: _isGridView,
        onSortChanged: (sort) {
          setState(() {
            _currentSort = sort;
            _sortScripts();
          });
        },
        onViewModeChanged: (isGrid) {
          setState(() {
            _isGridView = isGrid;
          });
        },
      ),
    );
  }

  void _showImportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ImportOptionsBottomSheetWidget(
        onCameraScan: () {
          Fluttertoast.showToast(
            msg: 'Opening camera scanner',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
        onFilesApp: () {
          Fluttertoast.showToast(
            msg: 'Opening file picker',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
        onCloudStorage: () {
          Fluttertoast.showToast(
            msg: 'Connecting to cloud storage',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
        onCreateNew: () {
          Navigator.pushNamed(context, '/script-import');
        },
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate cloud sync
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    Fluttertoast.showToast(
      msg: 'Scripts synced successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _filterScripts() {
    _filteredScripts = _allScripts.where((script) {
      final title = (script['title'] as String? ?? '').toLowerCase();
      final preview = (script['preview'] as String? ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase();

      return title.contains(query) || preview.contains(query);
    }).toList();

    _sortScripts();
  }

  void _sortScripts() {
    switch (_currentSort) {
      case SortOption.recent:
        _filteredScripts.sort((a, b) {
          final aDate = DateTime.parse(a['lastModified'] as String? ?? '');
          final bDate = DateTime.parse(b['lastModified'] as String? ?? '');
          return bDate.compareTo(aDate);
        });
        break;
      case SortOption.alphabetical:
        _filteredScripts.sort((a, b) {
          final aTitle = a['title'] as String? ?? '';
          final bTitle = b['title'] as String? ?? '';
          return aTitle.compareTo(bTitle);
        });
        break;
      case SortOption.wordCount:
        _filteredScripts.sort((a, b) {
          final aCount = a['wordCount'] as int? ?? 0;
          final bCount = b['wordCount'] as int? ?? 0;
          return bCount.compareTo(aCount);
        });
        break;
      case SortOption.dateCreated:
        _filteredScripts.sort((a, b) {
          final aDate = DateTime.parse(a['createdDate'] as String? ?? '');
          final bDate = DateTime.parse(b['createdDate'] as String? ?? '');
          return bDate.compareTo(aDate);
        });
        break;
    }
  }

  void _navigateToTeleprompter(Map<String, dynamic> script) {
    Navigator.pushNamed(context, '/teleprompter-view', arguments: script);
  }

  void _handleEdit(Map<String, dynamic> script) {
    Fluttertoast.showToast(
      msg: 'Editing ${script['title']}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleDuplicate(Map<String, dynamic> script) {
    setState(() {
      final newScript = Map<String, dynamic>.from(script);
      newScript['id'] = _allScripts.length + 1;
      newScript['title'] = '${script['title']} (Copy)';
      newScript['lastModified'] = DateTime.now().toIso8601String();
      _allScripts.insert(0, newScript);
      _filterScripts();
    });

    Fluttertoast.showToast(
      msg: 'Script duplicated',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleShare(Map<String, dynamic> script) {
    Fluttertoast.showToast(
      msg: 'Sharing ${script['title']}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleDelete(Map<String, dynamic> script) {
    setState(() {
      _allScripts.removeWhere((s) => s['id'] == script['id']);
      _filterScripts();
    });

    Fluttertoast.showToast(
      msg: 'Script deleted',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleRename(Map<String, dynamic> script) {
    _showRenameDialog(script);
  }

  void _handleMoveToFolder(Map<String, dynamic> script) {
    Fluttertoast.showToast(
      msg: 'Moving ${script['title']} to folder',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleExport(Map<String, dynamic> script) {
    Fluttertoast.showToast(
      msg: 'Exporting ${script['title']}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showRenameDialog(Map<String, dynamic> script) {
    final TextEditingController controller = TextEditingController(
      text: script['title'] as String? ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Rename Script',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: TextField(
            controller: controller,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter new name',
              hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    script['title'] = controller.text.trim();
                    script['lastModified'] = DateTime.now().toIso8601String();
                    _filterScripts();
                  });
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: 'Script renamed',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }
}
