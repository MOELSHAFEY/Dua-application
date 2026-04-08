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
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey100,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: AppColors.grey300,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // Image Shimmer
                  ShimmerLoading.rounded(
                    width: 80,
                    height: 80,
                    borderRadius: 12,
                  ),
                  const SizedBox(width: 16),

                  // Info Shimmer
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Shimmer
                        ShimmerLoading.rounded(
                          width: double.infinity,
                          height: 18,
                          borderRadius: 4,
                        ),
                        const SizedBox(height: 8),
                        
                        // Price Badge Shimmer
                        ShimmerLoading.rounded(
                          width: 100,
                          height: 28,
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
