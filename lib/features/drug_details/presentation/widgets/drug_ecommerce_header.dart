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
              color: AppColors.textPrimary,
              height: 1.3,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),

          // Price Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.2), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sell_outlined, size: 18, color: AppColors.success),
                const SizedBox(width: 6),
                Text(
                  '${drug.price} جنيه مصري',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
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
