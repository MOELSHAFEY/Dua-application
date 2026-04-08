import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dua/core/theme/colors.dart';
import 'package:dua/features/drug_details/presentation/cubit/drug_details_state.dart';
import 'package:dua/core/widgets/shimmer_loading.dart';

class DrugInfoCard extends StatelessWidget {
  final DrugDetailsState state;
  final bool isTablet;

  const DrugInfoCard({
    super.key,
    required this.state,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    String infoText = '';
    if (state is DrugDetailsLoaded) {
      infoText = (state as DrugDetailsLoaded).info
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
    } else if (state is DrugDetailsError) {
      infoText = (state as DrugDetailsError).message;
    } else {
      infoText = 'جاري التحميل...';
    }

    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCardHeader(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: state is DrugDetailsLoading
                  ? FadeIn(
                      duration: const Duration(milliseconds: 400),
                      child: const DrugDetailShimmer(),
                    )
                  : SelectionArea(
                      child: Text(
                        infoText,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.cairo(
                          fontSize: 17,
                          height: 1.8,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCardHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'تفاصيل الدواء',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ],
      ),
    );
  }
}
