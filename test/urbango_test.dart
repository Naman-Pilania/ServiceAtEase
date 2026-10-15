import 'package:flutter_test/flutter_test.dart';
import 'package:project_name/data/mock_data.dart';
import 'package:project_name/models/booking_model.dart';
import 'package:project_name/providers/auth_provider.dart';
import 'package:project_name/providers/booking_provider.dart';
import 'package:project_name/providers/home_provider.dart';
import 'package:project_name/providers/partner_dashboard_provider.dart';

void main() {
  group('UrbanGo Provider & Logic Tests', () {
    test('AuthProvider state transitions', () {
      final auth = AuthProvider();
      expect(auth.state, AuthState.initial);

      auth.setRoleSelection();
      expect(auth.state, AuthState.roleSelection);

      // Customer flow
      auth.selectRole(false);
      expect(auth.isPartner, isFalse);
      expect(auth.state, AuthState.login);

      auth.setPhoneNumber('9876543210');
      auth.sendOtp();
      expect(auth.state, AuthState.otp);

      auth.verifyOtp('1234');
      expect(auth.isAuthenticated, isTrue);
      expect(auth.user, isNotNull);
      expect(auth.user!.isPartner, isFalse);
    });

    test('AuthProvider partner selection', () {
      final auth = AuthProvider();
      auth.selectRole(true);
      expect(auth.isPartner, isTrue);

      auth.verifyOtp('1234');
      expect(auth.user!.isPartner, isTrue);
    });

    test('HomeProvider categories and partner filtering', () {
      final home = HomeProvider();
      expect(home.categories.length, equals(12));

      // Online partners
      final onlinePartners = home.nearbyOnlinePartners;
      expect(onlinePartners, isNotEmpty);
      for (final p in onlinePartners) {
        expect(p.isOnline, isTrue);
      }

      // Filter by category
      final salonPartners = home.getOnlinePartnersForCategory('cat_salon');
      expect(salonPartners, isNotEmpty);
      for (final p in salonPartners) {
        expect(p.categoryId, equals('cat_salon'));
        expect(p.isOnline, isTrue);
      }
    });

    test('BookingProvider creates and cancels bookings', () {
      final bookingProvider = BookingProvider();
      final initialCount = bookingProvider.bookings.length;

      bookingProvider.selectService('s_01');
      bookingProvider.selectPartner('p_01');
      bookingProvider.selectTimeSlot('2:00 PM - 2:30 PM');
      bookingProvider.selectDate(DateTime.now().add(const Duration(days: 1)));
      bookingProvider.setAddress('456 MG Road, Bangalore');

      final newBooking = bookingProvider.createBooking(
        categoryId: 'cat_salon',
        amount: 328.0,
      );

      expect(newBooking.status, equals(BookingStatus.confirmed));
      expect(bookingProvider.bookings.length, equals(initialCount + 1));

      // Cancel booking
      bookingProvider.cancelBooking(newBooking.id);
      final cancelled = bookingProvider.bookings.firstWhere((b) => b.id == newBooking.id);
      expect(cancelled.status, equals(BookingStatus.cancelled));
    });

    test('PartnerDashboardProvider toggles online status and manages jobs', () {
      final partnerProvider = PartnerDashboardProvider();
      expect(partnerProvider.isOnline, isTrue);

      partnerProvider.toggleOnline();
      expect(partnerProvider.isOnline, isFalse);
      expect(partnerProvider.currentPartner.isOnline, isFalse);

      partnerProvider.toggleOnline();
      expect(partnerProvider.isOnline, isTrue);

      // Earnings calculations
      expect(partnerProvider.weeklyEarningsData.length, equals(7));
      expect(partnerProvider.weekDays.length, equals(7));
    });

    test('MockData contains expected categories and services', () {
      expect(MockData.categories.length, equals(12));
      expect(MockData.allServices.length, greaterThanOrEqualTo(30));
      expect(MockData.partners.length, greaterThanOrEqualTo(15));
      expect(MockData.promotions.length, greaterThanOrEqualTo(3));
    });
  });
}
