import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/mock_data.dart';
import '../../../models/partner_model.dart';
import '../../../models/service_category_model.dart';
import '../../../providers/booking_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common/rating_stars.dart';
import '../../../widgets/common/status_badge.dart';

enum PartnerFilter { all, nearest, topRated, priceLowToHigh }

class AvailablePartnersScreen extends StatefulWidget {
  final String? categoryId;

  const AvailablePartnersScreen({super.key, this.categoryId});

  @override
  State<AvailablePartnersScreen> createState() =>
      _AvailablePartnersScreenState();
}

class _AvailablePartnersScreenState extends State<AvailablePartnersScreen> {
  PartnerFilter _activeFilter = PartnerFilter.all;

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'P';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  Color _getAvatarColor(String name) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.categoryPlumber,
      AppColors.categoryDoctor,
      AppColors.categoryPainter,
      AppColors.categoryFitness,
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    String? resolvedCatId = widget.categoryId;
    try {
      final state = GoRouterState.of(context);
      resolvedCatId ??= state.uri.queryParameters['categoryId'] ??
          state.pathParameters['categoryId'] ??
          state.pathParameters['id'];
      if (resolvedCatId == null && state.extra is String) {
        resolvedCatId = state.extra as String;
      }
    } catch (_) {}

    ServiceCategory? category;
    List<PartnerModel> partnersList;

    if (resolvedCatId != null && resolvedCatId.isNotEmpty) {
      category = MockData.getCategoryById(resolvedCatId);
      partnersList = MockData.getPartnersByCategory(resolvedCatId);
    } else {
      partnersList = List.from(MockData.partners);
    }

    // Apply sorting based on active filter
    switch (_activeFilter) {
      case PartnerFilter.all:
        break;
      case PartnerFilter.nearest:
        partnersList.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case PartnerFilter.topRated:
        partnersList.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case PartnerFilter.priceLowToHigh:
        partnersList.sort(
            (a, b) => a.priceMultiplier.compareTo(b.priceMultiplier));
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Available Partners',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (category != null)
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: category.color,
                ),
              ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip('All', PartnerFilter.all),
                  const SizedBox(width: 8),
                  _buildFilterChip('Nearest', PartnerFilter.nearest,
                      icon: Icons.near_me_outlined),
                  const SizedBox(width: 8),
                  _buildFilterChip('Top Rated', PartnerFilter.topRated,
                      icon: Icons.star_rounded),
                  const SizedBox(width: 8),
                  _buildFilterChip('Price: Low to High',
                      PartnerFilter.priceLowToHigh,
                      icon: Icons.arrow_upward_rounded),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          // Partners List
          Expanded(
            child: partnersList.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.people_outline_rounded,
                              size: 40,
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No Partners Found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Try clearing the filters or check back later.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: partnersList.length,
                    itemBuilder: (context, index) {
                      final partner = partnersList[index];
                      return _buildPartnerCard(context, partner);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, PartnerFilter filter,
      {IconData? icon}) {
    final isSelected = _activeFilter == filter;

    return InkWell(
      onTap: () {
        setState(() {
          _activeFilter = filter;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerCard(BuildContext context, PartnerModel partner) {
    final avatarColor = _getAvatarColor(partner.name);

    // Resolve partner services
    final serviceNames = partner.serviceIds
        .map((sId) => MockData.getServiceById(sId)?.name)
        .whereType<String>()
        .take(3)
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push('/customer/partner/${partner.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Avatar, Info, StatusBadge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: avatarColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(partner.name),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: avatarColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            partner.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          RatingStars(
                            rating: partner.rating,
                            size: 14,
                            reviewCount: partner.totalReviews,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 13, color: AppColors.textLight),
                              const SizedBox(width: 3),
                              Text(
                                '${partner.distanceKm} km away',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•  ${partner.experienceYears} yrs exp',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    partner.isOnline
                        ? StatusBadge.online()
                        : StatusBadge.offline(),
                  ],
                ),

                const SizedBox(height: 12),

                // Services Chips
                if (serviceNames.isNotEmpty) ...[
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: serviceNames.map((name) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],

                const Divider(height: 16, color: AppColors.divider),

                // Bottom row: Jobs completed + Book Now Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${partner.completedJobs} jobs completed',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLight,
                      ),
                    ),
                    if (partner.isOnline)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final bookingProvider =
                              context.read<BookingProvider>();
                          bookingProvider.selectPartner(partner.id);

                          final selectedServiceId =
                              bookingProvider.selectedServiceId;
                          if (selectedServiceId != null &&
                              partner.serviceIds.contains(selectedServiceId)) {
                            context.push('/customer/booking/summary');
                          } else if (partner.serviceIds.isNotEmpty) {
                            bookingProvider
                                .selectService(partner.serviceIds.first);
                            context.push('/customer/booking/summary');
                          } else {
                            context.push('/customer/partner/${partner.id}');
                          }
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 14),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Offline',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
