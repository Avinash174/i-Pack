import 'package:flutter/material.dart';
import '../main.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String date;
  final IconData icon;
  final Color color;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.icon,
    required this.color,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'n1',
      title: 'Claim Approved',
      message: 'Your claim for screen repair on iPhone 15 Pro Max (Claim #CL-9382) has been approved. Payment will be processed shortly.',
      date: 'Today, 10:45 AM',
      icon: Icons.check_circle_outline_rounded,
      color: Colors.green,
      isRead: false,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Policy Added successfully',
      message: 'MacBook Pro 16" has been added to your coverage index. Policy document is available to download.',
      date: 'Yesterday, 4:20 PM',
      icon: Icons.shield_outlined,
      color: AppColors.ipackOrange,
      isRead: true,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Renew Scheduled',
      message: 'Auto-renewal invoice for iPad Pro coverage was successfully generated. Payment scheduled for July 12.',
      date: 'June 20, 2026',
      icon: Icons.calendar_month_outlined,
      color: AppColors.ipackBlue,
      isRead: true,
    ),
    NotificationItem(
      id: 'n4',
      title: 'Security Alert',
      message: 'New sign-in detected on iPhone 14 Pro from Mumbai, India.',
      date: 'June 18, 2026',
      icon: Icons.lock_outline,
      color: Colors.red,
      isRead: true,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _deleteNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF051124) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.ipackBlue,
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton.icon(
              onPressed: _markAllRead,
              icon: const Icon(Icons.mark_email_read_outlined, size: 16),
              label: const Text(
                'Mark read',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState(isDark)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                return Dismissible(
                  key: Key(notif.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 28),
                  ),
                  onDismissed: (_) => _deleteNotification(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? (notif.isRead ? AppColors.darkSurface : AppColors.darkSurface.withValues(alpha: 0.8)) 
                          : (notif.isRead ? Colors.white : Colors.blue.withValues(alpha: 0.03)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? (notif.isRead ? Colors.white.withValues(alpha: 0.06) : AppColors.ipackOrange.withValues(alpha: 0.2))
                            : (notif.isRead ? Colors.grey[200]! : AppColors.ipackBlue.withValues(alpha: 0.1)),
                        width: notif.isRead ? 1.0 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.01),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: notif.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(notif.icon, color: notif.color, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notif.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : AppColors.ipackBlue,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    notif.date,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isDark ? Colors.white38 : Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notif.message,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.4,
                                  color: isDark ? Colors.white60 : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.ipackBlue.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              color: AppColors.ipackOrange,
              size: 48,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'All Caught Up',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You do not have any new notifications.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
