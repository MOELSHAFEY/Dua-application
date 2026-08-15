import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/colors.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerLoading.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerLoading.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  ShimmerLoading.rounded({
    super.key,
    this.width = double.infinity,
    required this.height,
    double borderRadius = 12,
  }) : shapeBorder = RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.surfaceElevatedDark : AppColors.grey200;
    final highlightColor = isDark ? AppColors.cardBackgroundDark : AppColors.grey100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.grey300,
          shape: shapeBorder,
        ),
      ),
    );
  }
}

class DrugListShimmer extends StatelessWidget {
  const DrugListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Image Shimmer
                  ShimmerLoading.rounded(
                    width: 72,
                    height: 72,
                    borderRadius: 10,
                  ),
                  const SizedBox(width: 14),

                  // Info Shimmer
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Shimmer
                        ShimmerLoading.rounded(
                          width: double.infinity,
                          height: 16,
                          borderRadius: 4,
                        ),
                        const SizedBox(height: 10),

                        // Price Badge Shimmer
                        ShimmerLoading.rounded(
                          width: 90,
                          height: 24,
                          borderRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DrugDetailShimmer extends StatelessWidget {
  const DrugDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerLoading.rounded(height: 24, width: 200),
        const SizedBox(height: 16),
        ShimmerLoading.rounded(height: 16),
        const SizedBox(height: 8),
        ShimmerLoading.rounded(height: 16),
        const SizedBox(height: 8),
        ShimmerLoading.rounded(height: 16, width: 250),
        const SizedBox(height: 24),
        ShimmerLoading.rounded(height: 20, width: 150),
        const SizedBox(height: 16),
        ShimmerLoading.rounded(height: 100),
      ],
    );
  }
}
