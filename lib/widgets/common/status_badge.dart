import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final bool isSmall;

  const StatusBadge({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.icon,
    this.isSmall = false,
  });

  factory StatusBadge.online() => const StatusBadge(
        text: 'Online',
        color: AppColors.online,
        icon: Icons.circle,
        isSmall: true,
      );

  factory StatusBadge.offline() => const StatusBadge(
        text: 'Offline',
        color: AppColors.offline,
        icon: Icons.circle,
        isSmall: true,
      );

  factory StatusBadge.pending() => const StatusBadge(
        text: 'Pending',
        color: AppColors.warning,
      );

  factory StatusBadge.confirmed() => const StatusBadge(
        text: 'Confirmed',
        color: AppColors.info,
      );

  factory StatusBadge.inProgress() => const StatusBadge(
        text: 'In Progress',
        color: AppColors.primary,
      );

  factory StatusBadge.completed() => const StatusBadge(
        text: 'Completed',
        color: AppColors.success,
      );

  factory StatusBadge.cancelled() => const StatusBadge(
        text: 'Cancelled',
        color: AppColors.error,
      );

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppColors.primary;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: isSmall ? 6 : 8,
              color: badgeColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor ?? badgeColor,
              fontSize: isSmall ? 10 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
