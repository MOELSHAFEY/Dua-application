import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dua/core/theme/colors.dart';
import 'package:dua/core/entities/drug.dart';

class DrugEcommerceHeader extends StatelessWidget {
  final Drug drug;
  final bool isTablet;

  const DrugEcommerceHeader({
    super.key,
    required this.drug,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priceBg = isDark
        ? AppColors.successBackgroundDark.withValues(alpha: 0.4)
        : AppColors.successLight;
    final priceBorder = isDark
        ? AppColors.successDark.withValues(alpha: 0.3)
        : AppColors.success.withValues(alpha: 0.2);
    final priceTextColor = isDark ? AppColors.successDark : AppColors.success;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drug Name
          Text(
            drug.name,
            style: GoogleFonts.cairo(
              fontSize: isTablet ? 26 : 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.3,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),

          // Price Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: priceBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: priceBorder, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sell_outlined, size: 18, color: priceTextColor),
                const SizedBox(width: 6),
                Text(
                  '${drug.price} جنيه مصري',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: priceTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
