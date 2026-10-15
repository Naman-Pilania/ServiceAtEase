import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/booking_model.dart';
import '../models/partner_model.dart';

class PartnerDashboardProvider extends ChangeNotifier {
  bool _isOnline = true;
  PartnerModel _currentPartner = MockData.partners.first;
  final List<BookingModel> _partnerBookings = List.from(MockData.bookings);

  bool get isOnline => _isOnline;
  PartnerModel get currentPartner => _currentPartner;

  double get todayEarnings {
    final today = DateTime.now();
    return _partnerBookings
        .where((b) =>
            b.status == BookingStatus.completed &&
            b.bookingDate.day == today.day &&
            b.bookingDate.month == today.month &&
            b.bookingDate.year == today.year)
        .fold(0.0, (sum, b) => sum + b.totalAmount);
  }

  double get weeklyEarnings {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _partnerBookings
        .where((b) =>
            b.status == BookingStatus.completed &&
            b.bookingDate.isAfter(weekAgo))
        .fold(0.0, (sum, b) => sum + b.totalAmount);
  }

  double get monthlyEarnings {
    final monthAgo = DateTime.now().subtract(const Duration(days: 30));
    return _partnerBookings
        .where((b) =>
            b.status == BookingStatus.completed &&
            b.bookingDate.isAfter(monthAgo))
        .fold(0.0, (sum, b) => sum + b.totalAmount);
  }

  int get todayBookingsCount {
    final today = DateTime.now();
    return _partnerBookings
        .where((b) =>
            b.bookingDate.day == today.day &&
            b.bookingDate.month == today.month &&
            b.bookingDate.year == today.year &&
            b.status != BookingStatus.cancelled)
        .length;
  }

  List<BookingModel> get todayBookings {
    final today = DateTime.now();
    return _partnerBookings
        .where((b) =>
            b.bookingDate.day == today.day &&
            b.bookingDate.month == today.month &&
            b.bookingDate.year == today.year &&
            b.status != BookingStatus.cancelled)
        .toList();
  }

  List<BookingModel> get upcomingBookings {
    return _partnerBookings
        .where((b) =>
            b.bookingDate.isAfter(DateTime.now()) &&
            (b.status == BookingStatus.confirmed ||
             b.status == BookingStatus.pending))
        .toList()
      ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
  }

  List<BookingModel> get completedBookings {
    return _partnerBookings
        .where((b) => b.status == BookingStatus.completed)
        .toList()
      ..sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
  }

  List<BookingModel> get allBookings => _partnerBookings;

  // Mock weekly earnings data for chart
  List<double> get weeklyEarningsData => [
    1200, 800, 1500, 950, 1800, 1100, 1400,
  ];

  List<String> get weekDays => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  void toggleOnline() {
    _isOnline = !_isOnline;
    _currentPartner = _currentPartner.copyWith(isOnline: _isOnline);
    notifyListeners();
  }

  void acceptBooking(String bookingId) {
    final index = _partnerBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _partnerBookings[index] = _partnerBookings[index].copyWith(
        status: BookingStatus.confirmed,
      );
      notifyListeners();
    }
  }

  void rejectBooking(String bookingId) {
    final index = _partnerBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _partnerBookings[index] = _partnerBookings[index].copyWith(
        status: BookingStatus.cancelled,
      );
      notifyListeners();
    }
  }

  void completeBooking(String bookingId) {
    final index = _partnerBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _partnerBookings[index] = _partnerBookings[index].copyWith(
        status: BookingStatus.completed,
      );
      notifyListeners();
    }
  }

  void startBooking(String bookingId) {
    final index = _partnerBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _partnerBookings[index] = _partnerBookings[index].copyWith(
        status: BookingStatus.inProgress,
      );
      notifyListeners();
    }
  }
}
