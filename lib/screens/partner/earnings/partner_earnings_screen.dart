import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../models/booking_model.dart';
import '../../../providers/partner_dashboard_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common/status_badge.dart';

class PartnerEarningsScreen extends StatelessWidget {
  final bool isStandalone;

  const PartnerEarningsScreen({super.key, this.isStandalone = false});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PartnerDashboardProvider>();

    final todayVal = provider.todayEarnings > 0 ? provider.todayEarnings : 1200.0;
    final weeklyVal = provider.weeklyEarnings > 0 ? provider.weeklyEarnings : 8750.0;
    final monthlyVal = provider.monthlyEarnings > 0 ? provider.monthlyEarnings : 34200.0;

    final weeklyData = provider.weeklyEarningsData;
    final weekDays = provider.weekDays;
    final maxEarning = weeklyData.reduce((a, b) => a > b ? a : b);

    final content = SafeArea(
      top: !isStandalone,
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Top Total Balance Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Payout Balance',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Auto-Payouts',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${monthlyVal.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Next Payout: Monday to HDFC **** 4812',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 18),

        // 3 Summary Cards: Today / This Week / This Month
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Today',
                amount: '₹${todayVal.toStringAsFixed(0)}',
                trend: '+8%',
                color: AppColors.primary,
                bgColor: AppColors.primarySurface,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSummaryCard(
                title: 'This Week',
                amount: '₹${weeklyVal.toStringAsFixed(0)}',
                trend: '+14%',
                color: AppColors.success,
                bgColor: AppColors.success.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSummaryCard(
                title: 'This Month',
                amount: '₹${monthlyVal.toStringAsFixed(0)}',
                trend: '+22%',
                color: Color(0xFFD97706),
                bgColor: Color(0xFFFEF3C7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),

        // Weekly Earnings Custom Bar Chart
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Earnings',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Last 7 days performance',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Mon - Sun',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 7 Bars Chart using plain Container widgets
              SizedBox(
                height: 170,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(weeklyData.length, (index) {
                    final amount = weeklyData[index];
                    final day = weekDays[index];
                    // Scale height from 30px to 120px
                    final barHeight = maxEarning > 0
                        ? 30.0 + (amount / maxEarning) * 90.0
                        : 30.0;
                    final isPeak = amount == maxEarning;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Tooltip text above bar
                        Text(
                          amount >= 1000
                              ? '₹${(amount / 1000).toStringAsFixed(1)}k'
                              : '₹${amount.toInt()}',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: isPeak ? FontWeight.bold : FontWeight.w500,
                            color: isPeak ? AppColors.primary : AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Bar Container
                        Container(
                          width: 28,
                          height: barHeight,
                          decoration: BoxDecoration(
                            gradient: isPeak
                                ? AppColors.secondaryGradient
                                : AppColors.primaryGradient,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            boxShadow: isPeak
                                ? [
                                    BoxShadow(
                                      color: AppColors.secondary.withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Day Label
                        Text(
                          day,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: isPeak ? FontWeight.bold : FontWeight.w500,
                            color: isPeak ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Recent Transactions Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'All Completed',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Transactions List
        _buildTransactionItem(
          serviceName: 'Haircut & Styling',
          customer: 'Amit Kumar',
          date: 'Today, 02:30 PM',
          amount: 299.0,
          status: BookingStatus.completed,
          icon: '✂️',
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
          serviceName: 'Beard Trim & Clean Shave',
          customer: 'Rahul Sharma',
          date: 'Yesterday, 04:15 PM',
          amount: 248.0,
          status: BookingStatus.completed,
          icon: '🧔',
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
          serviceName: 'Relaxing Head Massage',
          customer: 'Venkat Rao',
          date: '13 Oct, 11:00 AM',
          amount: 199.0,
          status: BookingStatus.completed,
          icon: '💆',
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
          serviceName: 'Global Hair Color',
          customer: 'Deepak Verma',
          date: '11 Oct, 03:00 PM',
          amount: 999.0,
          status: BookingStatus.completed,
          icon: '🎨',
        ),
        const SizedBox(height: 10),
        _buildTransactionItem(
          serviceName: 'Weekly Platform Bonus',
          customer: 'serviceAtEase Rewards',
          date: '10 Oct, 09:00 AM',
          amount: 500.0,
          status: BookingStatus.completed,
          icon: '🎁',
        ),
        const SizedBox(height: 20),
      ],
      ),
    ),
    );

    if (isStandalone) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Earnings',
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

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required String trend,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  trend,
                  style: GoogleFonts.poppins(
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String serviceName,
    required String customer,
    required String date,
    required double amount,
    required BookingStatus status,
    required String icon,
  }) {
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
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 20),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$customer • $date',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
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
                '+₹${amount.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 4),
              StatusBadge.completed(),
            ],
          ),
        ],
      ),
    );
  }
}
