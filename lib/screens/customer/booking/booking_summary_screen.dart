import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/mock_data.dart';
import '../../../models/partner_model.dart';
import '../../../models/service_category_model.dart';
import '../../../models/service_model.dart';
import '../../../providers/booking_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common/gradient_button.dart';
import '../../../widgets/common/rating_stars.dart';

class BookingSummaryScreen extends StatefulWidget {
  final String? serviceId;
  final String? partnerId;

  const BookingSummaryScreen({
    super.key,
    this.serviceId,
    this.partnerId,
  });

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  late TextEditingController _addressController;
  late TextEditingController _notesController;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    final bookingProvider = context.read<BookingProvider>();

    if (widget.serviceId != null) {
      bookingProvider.selectService(widget.serviceId!);
    } else if (bookingProvider.selectedServiceId == null) {
      bookingProvider.selectService(MockData.allServices.first.id);
    }

    if (widget.partnerId != null) {
      bookingProvider.selectPartner(widget.partnerId!);
    } else if (bookingProvider.selectedPartnerId == null) {
      bookingProvider.selectPartner(MockData.partners.first.id);
    }

    if (bookingProvider.selectedTimeSlot == null &&
        bookingProvider.availableTimeSlots.isNotEmpty) {
      bookingProvider.selectTimeSlot(bookingProvider.availableTimeSlots.first);
    }

    _addressController = TextEditingController(
      text: bookingProvider.address.isNotEmpty
          ? bookingProvider.address
          : MockData.currentUser.address,
    );
    _notesController = TextEditingController(text: bookingProvider.notes);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();

    final serviceId = bookingProvider.selectedServiceId ??
        widget.serviceId ??
        MockData.allServices.first.id;
    final partnerId = bookingProvider.selectedPartnerId ??
        widget.partnerId ??
        MockData.partners.first.id;

    final service = MockData.getServiceById(serviceId) ??
        MockData.allServices.first;
    final partner = MockData.getPartnerById(partnerId) ??
        MockData.partners.first;
    final category = MockData.getCategoryById(service.categoryId) ??
        MockData.categories.first;

    final basePrice = service.basePrice;
    final serviceFee = (basePrice * partner.priceMultiplier).roundToDouble();
    const convenienceFee = 29.0;
    final totalAmount = serviceFee + convenienceFee;

    final selectedDate = bookingProvider.selectedDate;
    final selectedSlot = bookingProvider.selectedTimeSlot;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Booking Summary'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Details Card
            _buildSectionHeader('Selected Service'),
            const SizedBox(height: 8),
            _buildServiceCard(service, category, serviceFee),

            const SizedBox(height: 20),

            // Partner Details Card
            _buildSectionHeader('Assigned Professional'),
            const SizedBox(height: 8),
            _buildPartnerCard(partner),

            const SizedBox(height: 20),

            // Date Picker (Next 7 Days)
            _buildSectionHeader('Select Date'),
            const SizedBox(height: 8),
            _buildDateSelector(bookingProvider, selectedDate),

            const SizedBox(height: 20),

            // Time Slot Grid (3 columns)
            _buildSectionHeader('Select Time Slot'),
            const SizedBox(height: 8),
            _buildTimeSlotGrid(bookingProvider, selectedSlot),

            const SizedBox(height: 20),

            // Address Input Field
            _buildSectionHeader('Service Address'),
            const SizedBox(height: 8),
            _buildAddressField(),

            const SizedBox(height: 20),

            // Notes Field (Optional)
            _buildSectionHeader('Special Instructions (Optional)'),
            const SizedBox(height: 8),
            _buildNotesField(),

            const SizedBox(height: 24),

            // Price Breakdown Card
            _buildSectionHeader('Payment Summary'),
            const SizedBox(height: 8),
            _buildPriceBreakdownCard(serviceFee, convenienceFee, totalAmount),

            const SizedBox(height: 28),

            // Confirm Booking Button
            GradientButton(
              text: 'Confirm Booking • ₹${totalAmount.toInt()}',
              icon: Icons.check_circle_outline,
              isLoading: _isBooking,
              onPressed: () async {
                if (bookingProvider.selectedTimeSlot == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a time slot'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                if (_addressController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter service address'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                setState(() => _isBooking = true);
                bookingProvider.setAddress(_addressController.text.trim());
                bookingProvider.setNotes(_notesController.text.trim());

                final newBooking = bookingProvider.createBooking(
                  categoryId: category.id,
                  amount: totalAmount,
                );

                setState(() => _isBooking = false);

                context.push(
                  '/customer/booking/confirmation',
                  extra: newBooking,
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildServiceCard(
      ServiceModel service, ServiceCategory category, double serviceFee) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                service.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${category.name} • ${service.durationMinutes} mins',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${serviceFee.toInt()}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerCard(PartnerModel partner) {
    final avatarColor = _getAvatarColor(partner.name);

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: avatarColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getInitials(partner.name),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: avatarColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partner.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                RatingStars(
                  rating: partner.rating,
                  size: 13,
                  reviewCount: partner.totalReviews,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.navigation_outlined,
                    size: 12, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  '${partner.distanceKm} km',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(
      BookingProvider provider, DateTime selectedDate) {
    final now = DateTime.now();
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return SizedBox(
      height: 82,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = now.add(Duration(days: index));
          final isSelected = _isSameDay(date, selectedDate);
          final dayName = index == 0
              ? 'Today'
              : index == 1
                  ? 'Tmrw'
                  : weekDays[date.weekday - 1];

          return GestureDetector(
            onTap: () => provider.selectDate(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              margin: EdgeInsets.only(right: index == 6 ? 0 : 10),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.border,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    months[date.month - 1],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.9)
                          : AppColors.textLight,
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

  Widget _buildTimeSlotGrid(
      BookingProvider provider, String? selectedSlot) {
    final slots = provider.availableTimeSlots;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.3,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = slot == selectedSlot;

        return InkWell(
          onTap: () => provider.selectTimeSlot(slot),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                slot,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: TextField(
        controller: _addressController,
        maxLines: 2,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Enter complete address with flat / building name',
          hintStyle:
              const TextStyle(fontSize: 13, color: AppColors.textLight),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Icon(Icons.location_on_outlined,
                color: AppColors.categoryPlumber, size: 22),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: TextField(
        controller: _notesController,
        maxLines: 2,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: const InputDecoration(
          hintText: 'e.g. Ring the bell twice, bring cleaning liquid...',
          hintStyle: TextStyle(fontSize: 13, color: AppColors.textLight),
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Icon(Icons.edit_note_rounded,
                color: AppColors.textLight, size: 22),
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPriceBreakdownCard(
      double serviceFee, double convenienceFee, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          _buildPriceRow('Service Fee', '₹${serviceFee.toInt()}'),
          const SizedBox(height: 8),
          _buildPriceRow('Convenience & Safety Fee', '₹${convenienceFee.toInt()}'),
          const Divider(height: 20, color: AppColors.divider),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Total Payable',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹${total.toInt()}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
