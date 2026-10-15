import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/partner_dashboard_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common/rating_stars.dart';
import '../notifications/notifications_screen.dart';
import '../reviews/partner_reviews_screen.dart';
import '../services/service_setup_screen.dart';

class PartnerProfileScreen extends StatelessWidget {
  final bool isStandalone;

  const PartnerProfileScreen({super.key, this.isStandalone = false});

  void _navigateTo(BuildContext context, String route, Widget fallbackWidget) {
    try {
      context.push(route);
    } catch (_) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => fallbackWidget),
      );
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Log Out',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to log out from your partner account?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.read<AuthProvider>().logout();
              try {
                context.go('/');
              } catch (_) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Log Out',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDocumentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: MediaQuery.of(sheetCtx).padding.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Partner Documents',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Verified government ID and professional certifications',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildDocTile('Aadhaar Card', 'Verified on 12 Jan 2024', Icons.badge_outlined, true),
            const SizedBox(height: 10),
            _buildDocTile('PAN Card', 'Verified on 12 Jan 2024', Icons.credit_card_outlined, true),
            const SizedBox(height: 10),
            _buildDocTile('Trade Certification', 'Verified & Active', Icons.workspace_premium_outlined, true),
            const SizedBox(height: 10),
            _buildDocTile('Bank Passbook / Cancelled Cheque', 'Primary Account linked', Icons.account_balance_outlined, true),
          ],
        ),
      ),
    );
  }

  static Widget _buildDocTile(String title, String subtitle, IconData icon, bool verified) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (verified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 12, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showHelpModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: MediaQuery.of(sheetCtx).padding.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Help & Support',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary),
              title: Text('Call Partner Support', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text('24x7 helpline: 1800-420-9999', style: GoogleFonts.poppins(fontSize: 12)),
              onTap: () => Navigator.of(sheetCtx).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.info),
              title: Text('Live Chat with Support', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text('Instant replies in under 2 minutes', style: GoogleFonts.poppins(fontSize: 12)),
              onTap: () => Navigator.of(sheetCtx).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.question_answer_outlined, color: AppColors.warning),
              title: Text('Frequently Asked Questions', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text('Payouts, bookings, profile guide', style: GoogleFonts.poppins(fontSize: 12)),
              onTap: () => Navigator.of(sheetCtx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 14,
              bottom: MediaQuery.of(sheetCtx).padding.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Preferences & Settings',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  value: true,
                  onChanged: (val) {},
                  title: Text('Sound Notifications', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: Text('Play chime on incoming booking', style: GoogleFonts.poppins(fontSize: 12)),
                  activeThumbColor: AppColors.primary,
                ),
                SwitchListTile(
                  value: true,
                  onChanged: (val) {},
                  title: Text('Auto-accept Instant Bookings', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: Text('Immediately confirm matched clients', style: GoogleFonts.poppins(fontSize: 12)),
                  activeThumbColor: AppColors.primary,
                ),
                ListTile(
                  leading: const Icon(Icons.language_rounded, color: AppColors.textSecondary),
                  title: Text('App Language', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  trailing: Text('English', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final partner = context.watch<PartnerDashboardProvider>().currentPartner;
    final initials = partner.name
        .trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join();

    final content = SafeArea(
      top: !isStandalone,
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        // Profile Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Large Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: partner.isOnline ? AppColors.online : AppColors.offline,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Name
              Text(
                partner.name,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),

              // Phone & Address
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone_outlined, size: 14, color: AppColors.textLight),
                  const SizedBox(width: 4),
                  Text(
                    partner.phone,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textLight),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      partner.address,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Rating Display
              RatingStars(
                rating: partner.rating,
                size: 16,
                reviewCount: partner.totalReviews,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Stats Row: Completed Jobs | Experience | Total Reviews
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  value: '${partner.completedJobs}',
                  label: 'Completed Jobs',
                  icon: Icons.task_alt_rounded,
                  iconColor: AppColors.success,
                ),
              ),
              const SizedBox(
                height: 40,
                child: VerticalDivider(color: AppColors.border, thickness: 1),
              ),
              Expanded(
                child: _buildStatItem(
                  value: '${partner.experienceYears} Yrs',
                  label: 'Experience',
                  icon: Icons.work_history_rounded,
                  iconColor: AppColors.primary,
                ),
              ),
              const SizedBox(
                height: 40,
                child: VerticalDivider(color: AppColors.border, thickness: 1),
              ),
              Expanded(
                child: _buildStatItem(
                  value: '${partner.totalReviews}',
                  label: 'Reviews',
                  icon: Icons.rate_review_rounded,
                  iconColor: AppColors.warning,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Menu Section
        Text(
          'Account & Operations',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border, width: 0.8),
          ),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.home_repair_service_rounded,
                iconColor: AppColors.primary,
                title: 'My Services',
                subtitle: '${partner.serviceIds.length} services configured',
                onTap: () => _navigateTo(
                  context,
                  '/partner/services',
                  const ServiceSetupScreen(),
                ),
              ),
              const Divider(color: AppColors.divider, height: 1),
              _buildMenuItem(
                icon: Icons.star_outline_rounded,
                iconColor: AppColors.warning,
                title: 'Reviews',
                subtitle: '${partner.rating} average (${partner.totalReviews} total)',
                onTap: () => _navigateTo(
                  context,
                  '/partner/reviews',
                  const PartnerReviewsScreen(),
                ),
              ),
              const Divider(color: AppColors.divider, height: 1),
              _buildMenuItem(
                icon: Icons.description_outlined,
                iconColor: Color(0xFF0284C7),
                title: 'Documents',
                subtitle: 'ID proof, license & certifications',
                onTap: () => _showDocumentsSheet(context),
              ),
              const Divider(color: AppColors.divider, height: 1),
              _buildMenuItem(
                icon: Icons.notifications_none_rounded,
                iconColor: AppColors.secondary,
                title: 'Notifications',
                subtitle: 'Alerts, updates and bonuses',
                onTap: () => _navigateTo(
                  context,
                  '/partner/notifications',
                  const NotificationsScreen(),
                ),
              ),
              const Divider(color: AppColors.divider, height: 1),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                iconColor: AppColors.textSecondary,
                title: 'Settings',
                subtitle: 'Preferences, sound & alerts',
                onTap: () => _showSettingsModal(context),
              ),
              const Divider(color: AppColors.divider, height: 1),
              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                iconColor: AppColors.info,
                title: 'Help & Support',
                subtitle: '24/7 hotline, FAQ and live chat',
                onTap: () => _showHelpModal(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Logout Button
        Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.25),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _handleLogout(context),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Log Out',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
      ),
    ),
    );

    if (isStandalone) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Partner Profile',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          elevation: 0,
          backgroundColor: AppColors.surface,
          centerTitle: true,
        ),
        body: content,
      );
    }

    return content;
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
