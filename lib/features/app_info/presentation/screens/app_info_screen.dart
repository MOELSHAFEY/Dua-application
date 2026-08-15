import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dua/core/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeBg = isDark ? AppColors.surfaceElevatedDark : AppColors.grey100;
    final badgeBorder = isDark ? AppColors.borderDark : AppColors.border;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'عن التطبيق',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // App Logo & Version
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    Icons.medication_rounded,
                    size: 48,
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'دوا - Dua',
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'دليلك الدوائي الشامل والذكي',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: badgeBorder),
                ),
                child: Text(
                  'الاصدار 5.0.0',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Info Cards
              _buildSectionCard(
                context: context,
                title: 'حول التطبيق',
                icon: Icons.info_outline_rounded,
                content:
                    'تطبيق "دوا" هو تطبيق خدمي يهدف لتسهيل البحث عن الأدوية في السوق المصري، معرفة الأسعار المحدثة، واستعراض البدائل المتاحة بنفس المادة الفعالة.',
              ),
              const SizedBox(height: 12),
              _buildSectionCard(
                context: context,
                title: 'المميزات الرئيسية',
                icon: Icons.checklist_rounded,
                content:
                    '• البحث السريع بالاسم التجاري أو الاسم العلمي\n• البحث الصوتي السريع\n• استعراض أسعار الأدوية وبدائلها\n• حفظ الأدوية المفضلة لسهولة الرجوع إليها\n• مشاركة بطاقة الدواء ومعلوماته\n• دعم كامل للوضع الليلي وتكبير الخط',
              ),
              const SizedBox(height: 12),
              _buildSectionCard(
                context: context,
                title: 'تطوير وتصميم',
                icon: Icons.code_rounded,
                content:
                    'تم التطوير بواسطة: المهندس محمد الشافعي (MOELSHAFEY)\nلخدمة المرضى والصيادلة في المجتمع المصري.',
              ),
              const SizedBox(height: 12),
              _buildContactCard(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String content,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.send_rounded, color: Color(0xFF0088CC), size: 20),
              const SizedBox(width: 8),
              Text(
                'تواصل معنا',
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'للاقتراحات أو الإبلاغ عن أي مشكلة، يمكنك التواصل مباشرة عبر تليجرام:',
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _launchTelegram('MO_SH_FY'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088CC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.send_rounded, size: 16),
              label: Text(
                'مراسلة على تليجرام (@MO_SH_FY)',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchTelegram(String username) async {
    final url = 'https://t.me/$username';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
