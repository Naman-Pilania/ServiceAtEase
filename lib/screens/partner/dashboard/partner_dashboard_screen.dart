import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../data/mock_data.dart';
import '../../../models/booking_model.dart';
import '../../../models/partner_model.dart';
import '../../../providers/partner_dashboard_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common/status_badge.dart';
import '../bookings/partner_bookings_screen.dart';
import '../earnings/partner_earnings_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/partner_profile_screen.dart';
import '../requests/incoming_request_sheet.dart';

class PartnerDashboardScreen extends StatefulWidget {
  final int initialTabIndex;

  const PartnerDashboardScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PartnerDashboardProvider>();
    final partner = provider.currentPartner;

    final List<Widget> pages = [
      _buildDashboardTab(context, provider, partner),
      const PartnerBookingsScreen(isStandalone: false),
      const PartnerEarningsScreen(isStandalone: false),
      const PartnerProfileScreen(isStandalone: false),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _currentIndex == 0 ? _buildDashboardAppBar(context, partner) : null,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      floatingActionButton: _currentIndex == 0
          ? _buildIncomingRequestFab(context)
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabSelected,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textLight,
            selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                activeIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                activeIcon: Icon(Icons.calendar_month_rounded),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                activeIcon: Icon(Icons.account_balance_wallet_rounded),
                label: 'Earnings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildDashboardAppBar(
    BuildContext context,
    PartnerModel partner,
  ) {
    final initials = partner.name
        .trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join();

    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      toolbarHeight: 74,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Avatar circle with initials
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Greeting & Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome back,',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textLight,
                  ),
                ),
                Text(
                  partner.name,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            try {
              context.push('/partner/notifications');
            } catch (_) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            }
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textPrimary,
                  size: 22,
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDashboardTab(
    BuildContext context,
    PartnerDashboardProvider provider,
    PartnerModel partner,
  ) {
    final isOnline = provider.isOnline;
    final todayBookings = provider.todayBookings;
    final displayBookings = todayBookings.isNotEmpty
        ? todayBookings
        : provider.allBookings.take(3).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // ─── LARGE AVAILABILITY TOGGLE ────────────────────────────────
        _buildAvailabilityToggleCard(provider, isOnline),
        const SizedBox(height: 18),

        // ─── STATS ROW ───────────────────────────────────────────────
        Row(
          children: [
            // Today's Bookings
            Expanded(
              child: _buildStatCard(
                title: "Today's Jobs",
                value: '${provider.todayBookingsCount}',
                icon: Icons.calendar_today_rounded,
                iconColor: AppColors.primary,
                bgColor: AppColors.primarySurface,
              ),
            ),
            const SizedBox(width: 10),
            // Today's Earnings
            Expanded(
              child: _buildStatCard(
                title: "Earnings",
                value: '₹${provider.todayEarnings > 0 ? provider.todayEarnings.toStringAsFixed(0) : '1,200'}',
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppColors.success,
                bgColor: AppColors.success.withValues(alpha: 0.12),
              ),
            ),
            const SizedBox(width: 10),
            // Rating
            Expanded(
              child: _buildStatCard(
                title: 'Rating',
                value: '${partner.rating.toStringAsFixed(1)} ★',
                icon: Icons.star_rounded,
                iconColor: AppColors.warning,
                bgColor: const Color(0xFFFEF3C7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ─── TODAY'S SCHEDULE SECTION ─────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Today's Schedule",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${displayBookings.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                _onTabSelected(1); // Switch to Bookings tab
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  'See All',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Schedule cards
        if (displayBookings.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Icon(
                  Icons.event_available_outlined,
                  size: 48,
                  color: AppColors.textLight.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 10),
                Text(
                  'No bookings scheduled for today',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayBookings.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final booking = displayBookings[index];
              return _buildScheduleCard(booking);
            },
          ),
        const SizedBox(height: 80), // Padding for FAB
      ],
      ),
    );
  }

  /// Large availability toggle card with smooth animated transitions & glow
  Widget _buildAvailabilityToggleCard(
    PartnerDashboardProvider provider,
    bool isOnline,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isOnline
            ? const Color(0xFFF0FDF4) // Soft emerald surface
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline
              ? AppColors.online.withValues(alpha: 0.45)
              : AppColors.border,
          width: 1.5,
        ),
        boxShadow: [
          if (isOnline)
            BoxShadow(
              color: AppColors.online.withValues(alpha: 0.28),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          // Online / Offline Status Indicator Ring
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isOnline
                  ? AppColors.online.withValues(alpha: 0.15)
                  : AppColors.offline.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOnline ? Icons.wifi_tethering_rounded : Icons.portable_wifi_off_rounded,
              color: isOnline ? AppColors.online : AppColors.offline,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),

          // Online / Offline Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isOnline ? const Color(0xFF15803D) : AppColors.textSecondary,
                  ),
                  child: Text(isOnline ? "You're Online" : "You're Offline"),
                ),
                const SizedBox(height: 2),
                Text(
                  isOnline
                      ? 'Receiving instant booking requests'
                      : 'Go online to accept customer jobs',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isOnline
                        ? const Color(0xFF166534).withValues(alpha: 0.8)
                        : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),

          // Custom Animated Slider Switch
          InkWell(
            onTap: () {
              provider.toggleOnline();
            },
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 58,
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isOnline ? AppColors.online : AppColors.offline,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: isOnline ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isOnline ? Icons.check : Icons.close,
                    size: 16,
                    color: isOnline ? AppColors.online : AppColors.offline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(BookingModel booking) {
    final service = MockData.getServiceById(booking.serviceId);
    final serviceName = service?.name ?? 'Home Service';
    final serviceIcon = service?.icon ?? '✂️';
    final customerName = MockData.currentUser.name;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                serviceIcon,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$customerName • ${booking.timeSlot}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${booking.totalAmount.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              _buildMiniStatus(booking.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return StatusBadge.pending();
      case BookingStatus.confirmed:
        return StatusBadge.confirmed();
      case BookingStatus.inProgress:
        return StatusBadge.inProgress();
      case BookingStatus.completed:
        return StatusBadge.completed();
      case BookingStatus.cancelled:
        return StatusBadge.cancelled();
    }
  }

  Widget _buildIncomingRequestFab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.38),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          showIncomingRequestSheet(context);
        },
        backgroundColor: AppColors.secondary,
        elevation: 0,
        highlightElevation: 0,
        icon: const Icon(
          Icons.notifications_active_rounded,
          color: Colors.white,
        ),
        label: Text(
          'Incoming Request',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
