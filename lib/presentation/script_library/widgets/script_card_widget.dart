import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScriptCardWidget extends StatelessWidget {
  final Map<String, dynamic> script;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final VoidCallback onRename;
  final VoidCallback onMoveToFolder;
  final VoidCallback onExport;

  const ScriptCardWidget({
    super.key,
    required this.script,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onShare,
    required this.onDelete,
    required this.onRename,
    required this.onMoveToFolder,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(script['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit(),
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.textPrimary,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (_) => onDuplicate(),
              backgroundColor: AppTheme.success,
              foregroundColor: AppTheme.textPrimary,
              icon: Icons.copy,
              label: 'Duplicate',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (_) => onShare(),
              backgroundColor: AppTheme.warning,
              foregroundColor: AppTheme.textPrimary,
              icon: Icons.share,
              label: 'Share',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _showDeleteConfirmation(context),
              backgroundColor: AppTheme.error,
              foregroundColor: AppTheme.textPrimary,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          script['title'] as String? ?? 'Untitled Script',
                          style: AppTheme.darkTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${script['wordCount'] ?? 0} words',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    script['preview'] as String? ?? 'No preview available',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'access_time',
                        color: AppTheme.textSecondary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Modified ${_formatDate(script['lastModified'])}',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      if (script['isOffline'] == true)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'cloud_off',
                                color: AppTheme.warning,
                                size: 12,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Offline',
                                style: AppTheme.darkTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.warning,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Script',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete "${script['title']}"? This action cannot be undone.',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
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
                Navigator.of(context).pop();
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
              ),
              child: Text(
                'Delete',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                script['title'] as String? ?? 'Script Options',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              _buildContextMenuItem(
                context,
                icon: 'edit',
                title: 'Rename',
                onTap: () {
                  Navigator.pop(context);
                  onRename();
                },
              ),
              _buildContextMenuItem(
                context,
                icon: 'folder',
                title: 'Move to Folder',
                onTap: () {
                  Navigator.pop(context);
                  onMoveToFolder();
                },
              ),
              _buildContextMenuItem(
                context,
                icon: 'file_download',
                title: 'Export',
                onTap: () {
                  Navigator.pop(context);
                  onExport();
                },
              ),
              _buildContextMenuItem(
                context,
                icon: 'copy',
                title: 'Duplicate',
                onTap: () {
                  Navigator.pop(context);
                  onDuplicate();
                },
              ),
              _buildContextMenuItem(
                context,
                icon: 'share',
                title: 'Share',
                onTap: () {
                  Navigator.pop(context);
                  onShare();
                },
              ),
              Divider(color: AppTheme.border),
              _buildContextMenuItem(
                context,
                icon: 'delete',
                title: 'Delete',
                color: AppTheme.error,
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: color ?? AppTheme.textPrimary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
          color: color ?? AppTheme.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown';

    try {
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return 'Unknown';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
