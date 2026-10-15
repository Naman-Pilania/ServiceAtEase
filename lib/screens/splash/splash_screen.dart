import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/common/urbango_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _ambientController;

  // Staggered Entrance Animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _rippleScale;
  late final Animation<double> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _badgesFade;
  late final Animation<double> _badgesScale;
  late final Animation<double> _bottomFade;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // 1. Entrance animation (1.4s)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    _rippleScale = Tween<double>(begin: 0.5, end: 1.4).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _titleSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeIn),
      ),
    );

    _badgesFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 0.85, curve: Curves.easeIn),
      ),
    );

    _badgesScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 0.9, curve: Curves.elasticOut),
      ),
    );

    _bottomFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );

    // 2. Ambient idle animation (2.6s loop)
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _entranceController.forward();

    // Navigate to onboarding after 2.8s
    _navigationTimer = Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _entranceController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth;
          final maxH = constraints.maxHeight;
          final isSmallScreen = maxH < 650;
          final scale = (math.min(maxW, maxH) / 400.0).clamp(0.8, 1.25);

          return Stack(
            children: [
              // 1. Dynamic Ambient Glowing Orbs Background
              _buildAnimatedBackground(maxW, maxH),

              // 2. Main Centered Interactive Hero Content
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // Central Logo with Ripple Aura & Floating Service Chips
                      _buildLogoCluster(scale, isSmallScreen),

                      SizedBox(height: isSmallScreen ? 16 : 28),

                      // Brand Name & Tagline
                      _buildBrandHeader(scale),

                      const Spacer(flex: 3),

                      // Bottom Live Dispatcher & Online Partners Status
                      _buildBottomStatus(scale, isSmallScreen),

                      SizedBox(height: isSmallScreen ? 16 : 28),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Ambient Animated Background with Breathing Gradient Aura Orbs
  Widget _buildAnimatedBackground(double width, double height) {
    return AnimatedBuilder(
      animation: _ambientController,
      builder: (context, child) {
        final t = _ambientController.value;
        final floatY = math.sin(t * math.pi) * 15.0;

        return Stack(
          children: [
            // Top-Right Electric Violet Orb
            Positioned(
              top: -80 + floatY,
              right: -60 - floatY,
              child: Container(
                width: width * 0.75,
                height: width * 0.75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryLight.withValues(alpha: 0.22 + (0.06 * t)),
                      AppColors.primaryLight.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Center-Left Coral Sunset Orb
            Positioned(
              bottom: height * 0.25 - floatY,
              left: -70 + floatY,
              child: Container(
                width: width * 0.65,
                height: width * 0.65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.secondaryLight.withValues(alpha: 0.18 + (0.05 * t)),
                      AppColors.secondaryLight.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom-Right Soft Emerald Dispatch Glow (Represents Online Partners)
            Positioned(
              bottom: -60 + floatY,
              right: -50,
              child: Container(
                width: width * 0.55,
                height: width * 0.55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.online.withValues(alpha: 0.12 + (0.04 * t)),
                      AppColors.online.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Central cluster featuring the logo, expanding ripples, and floating service badges
  Widget _buildLogoCluster(double scale, bool isSmallScreen) {
    final logoSize = (110.0 * scale).clamp(84.0, 130.0);
    final badgeRadius = (logoSize * 1.05).clamp(90.0, 140.0);

    return SizedBox(
      width: badgeRadius * 2.5,
      height: badgeRadius * 2.2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Concentric Animated Ripple Waves
          AnimatedBuilder(
            animation: _entranceController,
            builder: (context, child) {
              return Opacity(
                opacity: (1.0 - (_entranceController.value * 0.6)).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: _rippleScale.value,
                  child: Container(
                    width: logoSize * 1.7,
                    height: logoSize * 1.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // 2. Central UrbanGo Logo
          AnimatedBuilder(
            animation: _entranceController,
            builder: (context, child) {
              return Opacity(
                opacity: _logoFade.value,
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: UrbanGoLogo(
                    size: logoSize,
                    isAnimated: true,
                    showGlow: true,
                  ),
                ),
              );
            },
          ),

          // 3. Floating Category Badges (Only on regular screens to avoid overflow)
          if (!isSmallScreen) ...[
            _buildFloatingBadge(
              angle: -math.pi * 0.75, // Top-Left
              distance: badgeRadius,
              icon: '💇',
              label: 'Salon',
              color: AppColors.categorySalon,
              bobOffset: 0.0,
            ),
            _buildFloatingBadge(
              angle: -math.pi * 0.25, // Top-Right
              distance: badgeRadius,
              icon: '🩺',
              label: 'Doctor',
              color: AppColors.categoryDoctor,
              bobOffset: 1.0,
            ),
            _buildFloatingBadge(
              angle: math.pi * 0.78, // Bottom-Left
              distance: badgeRadius,
              icon: '⚡',
              label: 'Electrician',
              color: AppColors.categoryElectrician,
              bobOffset: 2.0,
            ),
            _buildFloatingBadge(
              angle: math.pi * 0.22, // Bottom-Right
              distance: badgeRadius,
              icon: '🧹',
              label: 'Cleaning',
              color: AppColors.categoryCleaning,
              bobOffset: 3.0,
            ),
          ],
        ],
      ),
    );
  }

  /// Floating service chip with bobbing animation
  Widget _buildFloatingBadge({
    required double angle,
    required double distance,
    required String icon,
    required String label,
    required Color color,
    required double bobOffset,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _ambientController]),
      builder: (context, child) {
        final t = _ambientController.value;
        final bob = math.sin((t * 2 * math.pi) + bobOffset) * 5.0;

        final x = math.cos(angle) * distance;
        final y = (math.sin(angle) * distance) + bob;

        return Transform.translate(
          offset: Offset(x, y),
          child: Opacity(
            opacity: _badgesFade.value,
            child: Transform.scale(
              scale: _badgesScale.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: color.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Brand Title "UrbanGo" and Tagline
  Widget _buildBrandHeader(double scale) {
    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        return Opacity(
          opacity: _titleFade.value,
          child: Transform.translate(
            offset: Offset(0, _titleSlide.value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gradient App Name
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    AppConstants.appName,
                    style: GoogleFonts.poppins(
                      fontSize: (40.0 * scale).clamp(32.0, 48.0),
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Branded Feature Pill Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryLight.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ON-DEMAND HOME & WELLNESS SERVICES',
                        style: GoogleFonts.poppins(
                          fontSize: (10.0 * scale).clamp(9.0, 11.5),
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  AppConstants.appTagline,
                  style: GoogleFonts.poppins(
                    fontSize: (14.0 * scale).clamp(12.0, 16.0),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Bottom Dispatch Status Bar (Matches Ola/Uber on-demand model)
  Widget _buildBottomStatus(double scale, bool isSmallScreen) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _ambientController]),
      builder: (context, child) {
        final t = _ambientController.value;

        return Opacity(
          opacity: _bottomFade.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Online Dispatch Capsule
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 36),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.border,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pulsing Online Green Radar Indicator
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 16 + (t * 8),
                          height: 16 + (t * 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.online.withValues(alpha: 0.35 * (1.0 - t)),
                          ),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.online,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),

                    // Dispatcher text
                    Text(
                      'Live Partner Radar Active',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.online.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '19+ FREE',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.online,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Mini Animated Loading Indicator Bar
              SizedBox(
                width: 120,
                height: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
