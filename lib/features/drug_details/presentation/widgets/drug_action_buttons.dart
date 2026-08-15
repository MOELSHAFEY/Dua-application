import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dua/core/theme/colors.dart';

class DrugActionButtons extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const DrugActionButtons({
    super.key,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: onFavoriteToggle,
        icon: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 20,
          color: isFavorite ? Colors.white : AppColors.error,
        ),
        label: Text(
          isFavorite ? 'تمت الإضافة للمفضلة' : 'إضافة إلى المفضلة',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isFavorite ? AppColors.error : cardBg,
          foregroundColor: isFavorite ? Colors.white : textColor,
          side: BorderSide(
            color: isFavorite ? AppColors.error : borderColor,
            width: 1,
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
