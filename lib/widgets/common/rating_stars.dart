import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showValue;
  final int? reviewCount;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.color,
    this.showValue = true,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          IconData iconData;
          if (rating >= starValue) {
            iconData = Icons.star_rounded;
          } else if (rating >= starValue - 0.5) {
            iconData = Icons.star_half_rounded;
          } else {
            iconData = Icons.star_outline_rounded;
          }
          return Icon(
            iconData,
            size: size,
            color: color ?? AppColors.warning,
          );
        }),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.8,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
        if (reviewCount != null) ...[
          const SizedBox(width: 2),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: size * 0.7,
              color: AppColors.textLight,
            ),
          ),
        ],
      ],
    );
  }
}
