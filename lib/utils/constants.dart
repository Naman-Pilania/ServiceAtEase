class AppConstants {
  AppConstants._();

  static const String appName = 'serviceAtEase';
  static const String appTagline = 'Instant Services. At Your Ease.';

  // Animation durations
  static const Duration quickAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 350);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Padding
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border Radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 100.0;

  // Avatar sizes
  static const double avatarSM = 36.0;
  static const double avatarMD = 48.0;
  static const double avatarLG = 64.0;
  static const double avatarXL = 80.0;

  // Onboarding
  static const List<Map<String, String>> onboardingData = [
    {
      'title': 'Find Services Near You',
      'description': 'Browse from dozens of service categories and find the right professional for your needs.',
      'icon': '🔍',
    },
    {
      'title': 'Real-Time Availability',
      'description': 'See which service partners are available right now and book them instantly.',
      'icon': '🟢',
    },
    {
      'title': 'Book & Relax',
      'description': 'Confirm your booking, track your partner, and enjoy a seamless service experience.',
      'icon': '✨',
    },
  ];
}
