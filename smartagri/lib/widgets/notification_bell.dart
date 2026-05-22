import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/notification_provider.dart';
import '../core/constants/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        final unreadCount = provider.unreadCount;

        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: 0, end: 3),
          showBadge: unreadCount > 0,
          badgeContent: Text(
            unreadCount.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showNotificationSheet(context, provider);
            },
          ),
        );
      },
    );
  }

  void _showNotificationSheet(BuildContext context, NotificationProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            final notifications = provider.notifications;
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifications',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (provider.unreadCount > 0)
                        TextButton(
                          onPressed: () {
                            provider.markAllAsRead();
                          },
                          child: const Text('Mark All as Read'),
                        ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: notifications.isEmpty
                      ? const Center(child: Text('No notifications'))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getIconColor(notification.type).withValues(alpha: 0.1),
                                child: Icon(
                                  _getIcon(notification.type),
                                  color: _getIconColor(notification.type),
                                ),
                              ),
                              title: Text(
                                notification.message,
                                style: TextStyle(
                                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                timeago.format(notification.timestamp),
                              ),
                              onTap: () {
                                if (!notification.isRead) {
                                  provider.markAsRead(notification.id);
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  IconData _getIcon(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
      case 'critical':
        return Icons.warning_amber_rounded;
      case 'info':
        return Icons.info_outline;
      case 'warning':
        return Icons.error_outline;
      default:
        return Icons.notifications_none;
    }
  }

  Color _getIconColor(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
      case 'critical':
        return AppColors.error;
      case 'info':
        return AppColors.info;
      case 'warning':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }
}
