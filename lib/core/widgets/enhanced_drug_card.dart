import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import 'package:dua/core/entities/drug.dart';
import 'package:dua/features/favorites/presentation/providers/favorites_provider.dart';

class EnhancedDrugCard extends StatelessWidget {
  final Drug drug;
  final VoidCallback onTap;
  final int index;
  final String searchQuery;

  const EnhancedDrugCard({
    super.key,
    required this.drug,
    required this.onTap,
    this.index = 0,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFavorite = favoritesProvider.isFavorite(drug.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final imageBg = isDark ? AppColors.surfaceElevatedDark : AppColors.grey50;

    final priceBg = isDark
        ? AppColors.successBackgroundDark.withValues(alpha: 0.4)
        : AppColors.successLight;
    final priceBorder = isDark
        ? AppColors.successDark.withValues(alpha: 0.3)
        : AppColors.success.withValues(alpha: 0.2);
    final priceTextColor = isDark ? AppColors.successDark : AppColors.success;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dismissible(
        key: Key('drug_card_${drug.id}'),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (_) async {
          HapticFeedback.mediumImpact();
          favoritesProvider.toggleFavorite(drug);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isFavorite
                    ? 'تمت إزالة ${drug.name} من المفضلة'
                    : 'تمت إضافة ${drug.name} إلى المفضلة',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              backgroundColor: isFavorite ? AppColors.textSecondary : AppColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );
          return false; // Keep the card in the list
        },
        background: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isFavorite ? AppColors.error : AppColors.success,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              Icon(
                isFavorite ? Icons.favorite_border_rounded : Icons.favorite_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: borderColor, width: 1),
          ),
          color: cardBg,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Drug Image Thumbnail
                  Hero(
                    tag: 'drug_${drug.id}',
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: imageBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor, width: 0.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: drug.image.contains('http')
                            ? FadeInImage(
                                placeholder: const AssetImage('assets/me2.png'),
                                image: NetworkImage(drug.image),
                                fit: BoxFit.cover,
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderIcon(context);
                                },
                              )
                            : _buildPlaceholderIcon(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Drug Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drug Name with keyword highlighting
                        _buildHighlightedName(drug.name, searchQuery, context),
                        const SizedBox(height: 8),

                        // Price Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: priceBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: priceBorder, width: 0.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sell_outlined, size: 14, color: priceTextColor),
                              const SizedBox(width: 4),
                              Text(
                                '${drug.price} جنيه',
                                style: GoogleFonts.cairo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: priceTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Trailing Favorite indicator / Arrow
                  if (isFavorite)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.favorite_rounded,
                        color: AppColors.error,
                        size: 16,
                      ),
                    ),
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 14,
                    color: isDark ? AppColors.textLightDark : AppColors.textLight,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedName(String text, String query, BuildContext context) {
    final cleanQuery = query.trim();
    final textColor = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final highlightColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final highlightBg = highlightColor.withValues(alpha: isDark ? 0.25 : 0.12);

    if (cleanQuery.isEmpty || !text.toLowerCase().contains(cleanQuery.toLowerCase())) {
      return Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: textColor,
          height: 1.3,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = cleanQuery.toLowerCase();
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        if (start < text.length) {
          spans.add(
            TextSpan(
              text: text.substring(start),
              style: TextStyle(color: textColor),
            ),
          );
        }
        break;
      }

      if (index > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, index),
            style: TextStyle(color: textColor),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + cleanQuery.length),
          style: TextStyle(
            color: highlightColor,
            fontWeight: FontWeight.w900,
            backgroundColor: highlightBg,
          ),
        ),
      );

      start = index + cleanQuery.length;
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: GoogleFonts.cairo(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        children: spans,
      ),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Icon(
        Icons.medication_outlined,
        size: 32,
        color: isDark ? AppColors.textLightDark : AppColors.textLight,
      ),
    );
  }
}
