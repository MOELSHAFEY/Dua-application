import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dua/core/theme/colors.dart';
import '../providers/drug_details_provider.dart';
import 'package:dua/core/widgets/shimmer_loading.dart';

class DrugInfoCard extends StatelessWidget {
  final DrugDetailsProvider provider;
  final bool isTablet;

  const DrugInfoCard({
    super.key,
    required this.provider,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final primaryColor = Theme.of(context).colorScheme.primary;

    String infoText = '';
    if (provider.isLoaded) {
      infoText = provider.drugInfo
          .replaceAll(
            RegExp(
              r'<style[^>]*>.*?</style>',
              multiLine: true,
              dotAll: true,
              caseSensitive: false,
            ),
            '',
          )
          .replaceAll(
            RegExp(
              r'<script[^>]*>.*?</script>',
              multiLine: true,
              dotAll: true,
              caseSensitive: false,
            ),
            '',
          )
          .replaceAll(
            RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false),
            '',
          )
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&quot;', '"')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .trim();
    } else if (provider.isError) {
      infoText = provider.errorMessage;
    } else {
      infoText = 'جاري التحميل...';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  color: primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'معلومات وتفاصيل الدواء',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: provider.isLoading
                ? const DrugDetailShimmer()
                : SelectionArea(
                    child: Text(
                      infoText,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        height: 1.8,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
