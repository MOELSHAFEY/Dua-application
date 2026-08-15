import 'package:flutter/material.dart';
import 'package:dua/core/theme/colors.dart';
import 'package:dua/core/entities/drug.dart';

class DrugProductImage extends StatelessWidget {
  final Drug drug;
  final VoidCallback onTap;

  const DrugProductImage({
    super.key,
    required this.drug,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final zoomBg = isDark ? AppColors.surfaceElevatedDark : AppColors.grey100;
    final zoomIconColor = isDark ? AppColors.textPrimaryDark : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            child: Hero(
              tag: 'drug_img_${drug.id}',
              child: Stack(
                children: [
                  Center(
                    child: drug.image.contains("http")
                        ? Image.network(
                            drug.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderImage(context),
                          )
                        : _buildPlaceholderImage(context),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: zoomBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.zoom_in_rounded,
                        color: zoomIconColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Icon(
        Icons.medication_outlined,
        size: 72,
        color: isDark ? AppColors.textLightDark : AppColors.textLight,
      ),
    );
  }
}
