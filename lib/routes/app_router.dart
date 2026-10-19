import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/booking_model.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/customer/home/customer_home_screen.dart';
import '../screens/customer/category/service_category_screen.dart';
import '../screens/customer/partners/available_partners_screen.dart';
import '../screens/customer/partners/partner_detail_screen.dart';
import '../screens/customer/booking/booking_summary_screen.dart';
import '../screens/customer/booking/booking_confirmation_screen.dart';
import '../screens/customer/my_bookings/booking_detail_screen.dart';
import '../screens/customer/my_bookings/my_bookings_screen.dart';
import '../screens/customer/profile/customer_profile_screen.dart';
import '../screens/partner/dashboard/partner_dashboard_screen.dart';
import '../screens/partner/bookings/partner_bookings_screen.dart';
import '../screens/partner/earnings/partner_earnings_screen.dart';
import '../screens/partner/profile/partner_profile_screen.dart';
import '../screens/partner/services/service_setup_screen.dart';
import '../screens/partner/reviews/partner_reviews_screen.dart';
import '../screens/partner/notifications/notifications_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash & Auth routes
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/otp', builder: (context, state) => const OtpScreen()),

      // Customer routes
      GoRoute(
        path: '/customer',
        builder: (context, state) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: '/customer/category/:categoryId',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId'];
          return ServiceCategoryScreen(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: '/customer/partners',
        builder: (context, state) {
          final catId = state.extra is String
              ? state.extra as String
              : state.uri.queryParameters['categoryId'];
          return AvailablePartnersScreen(categoryId: catId);
        },
      ),
      GoRoute(
        path: '/customer/partner/:partnerId',
        builder: (context, state) {
          final partnerId = state.pathParameters['partnerId'];
          return PartnerDetailScreen(partnerId: partnerId);
        },
      ),
      GoRoute(
        path: '/customer/booking/summary',
        builder: (context, state) {
          String? sId = state.uri.queryParameters['serviceId'];
          String? pId = state.uri.queryParameters['partnerId'];
          if (state.extra is Map) {
            final map = state.extra as Map;
            sId ??= map['serviceId']?.toString();
            pId ??= map['partnerId']?.toString();
          }
          return BookingSummaryScreen(serviceId: sId, partnerId: pId);
        },
      ),
      GoRoute(
        path: '/customer/booking/confirmation',
        builder: (context, state) {
          final booking = state.extra is BookingModel
              ? state.extra as BookingModel
              : null;
          return BookingConfirmationScreen(booking: booking);
        },
      ),
      GoRoute(
        path: '/customer/booking/:bookingId',
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId'];
          return BookingDetailScreen(bookingId: bookingId);
        },
      ),
      GoRoute(
        path: '/customer/bookings',
        builder: (context, state) => const MyBookingsScreen(),
      ),
      GoRoute(
        path: '/customer/profile',
        builder: (context, state) => const CustomerProfileScreen(),
      ),

      // Partner routes
      GoRoute(
        path: '/partner',
        builder: (context, state) => const PartnerDashboardScreen(),
      ),
      GoRoute(
        path: '/partner/bookings',
        builder: (context, state) =>
            const PartnerBookingsScreen(isStandalone: true),
      ),
      GoRoute(
        path: '/partner/earnings',
        builder: (context, state) =>
            const PartnerEarningsScreen(isStandalone: true),
      ),
      GoRoute(
        path: '/partner/profile',
        builder: (context, state) =>
            const PartnerProfileScreen(isStandalone: true),
      ),
      GoRoute(
        path: '/partner/services',
        builder: (context, state) => const ServiceSetupScreen(),
      ),
      GoRoute(
        path: '/partner/reviews',
        builder: (context, state) => const PartnerReviewsScreen(),
      ),
      GoRoute(
        path: '/partner/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
