import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A premium, scalable logo widget for UrbanGo.
/// Combines the app's brand gradient, ambient multi-layer glow,
/// and responsive vector geometry or high-res raster asset.
class UrbanGoLogo extends StatefulWidget {
  final double size;
  final bool isAnimated;
  final bool showGlow;
  final double? borderRadius;

  const UrbanGoLogo({
    super.key,
    this.size = 80,
    this.isAnimated = false,
    this.showGlow = true,
    this.borderRadius,
  });

  @override
  State<UrbanGoLogo> createState() => _UrbanGoLogoState();
}

class _UrbanGoLogoState extends State<UrbanGoLogo>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _pulseAnimation;
  Animation<double>? _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.isAnimated) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2200),
      )..repeat(reverse: true);

      _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOutSine),
      );

      _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    final radius = widget.borderRadius ?? (s * 0.24);

    Widget logoCore = Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C63FF),
            Color(0xFF5349E8),
            Color(0xFF3F35CE),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: widget.showGlow
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: s * 0.28,
                  offset: Offset(0, s * 0.12),
                  spreadRadius: s * 0.02,
                ),
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.20),
                  blurRadius: s * 0.20,
                  offset: Offset(s * 0.08, s * 0.08),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Inner subtle border highlight
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: math.max(1.0, s * 0.02),
                ),
              ),
            ),

            // High-res logo image with vector fallback
            Image.asset(
              'assets/images/app_logo.png',
              width: s,
              height: s,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildVectorFallback(s),
            ),

            // Optional shimmer sweep when animated
            if (widget.isAnimated && _shimmerAnimation != null)
              AnimatedBuilder(
                animation: _shimmerAnimation!,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shimmerAnimation!.value * s, 0),
                    child: Transform.rotate(
                      angle: 0.45,
                      child: Container(
                        width: s * 0.35,
                        height: s * 1.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.0),
                              Colors.white.withValues(alpha: 0.18),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );

    if (widget.isAnimated && _pulseAnimation != null) {
      return AnimatedBuilder(
        animation: _pulseAnimation!,
        builder: (context, child) => Transform.scale(
          scale: _pulseAnimation!.value,
          child: logoCore,
        ),
      );
    }

    return logoCore;
  }

  Widget _buildVectorFallback(double s) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Stylized "U"
        Icon(
          Icons.speed_rounded,
          size: s * 0.52,
          color: Colors.white,
        ),
        Positioned(
          top: s * 0.22,
          right: s * 0.22,
          child: Icon(
            Icons.bolt_rounded,
            size: s * 0.32,
            color: const Color(0xFFFFD166),
          ),
        ),
      ],
    );
  }
}

/// Alias for ServiceAtEase
typedef ServiceAtEaseLogo = UrbanGoLogo;
