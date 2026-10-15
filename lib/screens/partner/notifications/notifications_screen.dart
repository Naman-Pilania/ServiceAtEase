import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';

class PartnerNotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String timestamp;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  bool isUnread;

  PartnerNotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.isUnread = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<PartnerNotificationItem> _notifications = [
    PartnerNotificationItem(
      id: 'notif_1',
      title: 'New booking request from Rahul',
      subtitle: 'Haircut & styling request for today at 2:30 PM',
      timestamp: '2 min ago',
      icon: Icons.notifications_active_rounded,
      iconColor: AppColors.secondary,
      iconBgColor: const Color(0xFFFFECEF),
      isUnread: true,
    ),
    PartnerNotificationItem(
      id: 'notif_2',
      title: 'Booking #bk_003 completed',
      subtitle: 'Customer Sunil confirmed service completion and released payment',
      timestamp: '2 hours ago',
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.success,
      iconBgColor: const Color(0xFFE8F9EE),
      isUnread: true,
    ),
    PartnerNotificationItem(
      id: 'notif_3',
      title: 'New 5-star review received!',
      subtitle: '"Amazing haircut! Vikram is very skilled and professional."',
      timestamp: '1 day ago',
      icon: Icons.star_rounded,
      iconColor: AppColors.warning,
      iconBgColor: const Color(0xFFFEF7E8),
      isUnread: true,
    ),
    PartnerNotificationItem(
      id: 'notif_4',
      title: '₹1,499 credited to your account',
      subtitle: 'Payout for weekly completed jobs successfully transferred',
      timestamp: '2 days ago',
      icon: Icons.account_balance_wallet_rounded,
      iconColor: AppColors.primary,
      iconBgColor: const Color(0xFFEEEDFF),
      isUnread: false,
    ),
    PartnerNotificationItem(
      id: 'notif_5',
      title: 'Weekend bonus: Earn 2x on Saturday!',
      subtitle: 'Complete 4 or more bookings this Saturday to earn double rewards',
      timestamp: '3 days ago',
      icon: Icons.campaign_rounded,
      iconColor: Color(0xFF8B5CF6),
      iconBgColor: const Color(0xFFF3EEFF),
      isUnread: false,
    ),
    PartnerNotificationItem(
      id: 'notif_6',
      title: 'Booking #bk_001 confirmed',
      subtitle: 'Customer Amit confirmed appointment for 2:00 PM slot',
      timestamp: '4 days ago',
      icon: Icons.event_available_rounded,
      iconColor: AppColors.info,
      iconBgColor: const Color(0xFFEBF4FE),
      isUnread: false,
    ),
  ];

  int _selectedFilter = 0; // 0: All, 1: Unread

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isUnread = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'All notifications marked as read',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => n.isUnread).length;
    final displayedList = _selectedFilter == 0
        ? _notifications
        : _notifications.where((n) => n.isUnread).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.surface,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              try {
                context.pop();
              } catch (_) {}
            }
          },
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark read',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterTab(
                  index: 0,
                  title: 'All (${_notifications.length})',
                ),
                const SizedBox(width: 8),
                _buildFilterTab(
                  index: 1,
                  title: 'Unread ($unreadCount)',
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // Notifications List
          Expanded(
            child: displayedList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 56,
                          color: AppColors.textLight.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No unread notifications',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: displayedList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = displayedList[index];
                      return _buildNotificationCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({required int index, required String title}) {
    final isSelected = _selectedFilter == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(PartnerNotificationItem item) {
    return InkWell(
      onTap: () {
        setState(() {
          item.isUnread = !item.isUnread;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isUnread
              ? AppColors.primarySurface.withValues(alpha: 0.55)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isUnread
                ? AppColors.primaryLight.withValues(alpha: 0.4)
                : AppColors.border,
            width: item.isUnread ? 1.2 : 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  item.icon,
                  color: item.iconColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: item.isUnread ? FontWeight.w700 : FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (item.isUnread) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.timestamp,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
