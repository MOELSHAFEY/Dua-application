import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dua/core/theme/colors.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('عن التطبيق'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // App Logo & Name Section
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.gradientPrimaryStart, AppColors.gradientPrimaryEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.medication_liquid_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'دوا - Dua',
              style: GoogleFonts.cairo(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'مساعدك الطبي الذكي',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'الاصدار 1.0.0',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Info Sections
            _buildInfoCard(
              title: 'حول التطبيق',
              content: 'تطبيق "دوا" هو رفيقك الصحي المتكامل للبحث عن الأدوية، معرفة البدائل، وإدارة جدول أدويتك اليومي بكل سهولة وأمان.',
              icon: Icons.info_outline_rounded,
            ),
            
            _buildInfoCard(
              title: 'المميزات الرئيسية',
              content: '• بحث ذكي وشامل عن الأدوية\n'
                       '• معرفة البدائل المتاحة\n'
                       '• حفظ الأدوية المفضلة\n'
                       '• يتطلب اتصالاً بالإنترنت للبحث',
              icon: Icons.auto_awesome_rounded,
            ),

            _buildInfoCard(
              title: 'تطوير وتصميم',
              content: 'تم تطوير هذا التطبيق بحب لخدمة المجتمع الطبي والمرضى في مصر.\n\nالمطور: MOELSHAFEY',
              icon: Icons.code_rounded,
            ),

            const SizedBox(height: 40),
          
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              levelText(title, size: 18, weight: FontWeight.bold),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget levelText(String text, {double size = 16, FontWeight weight = FontWeight.normal}) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        fontSize: size,
        fontWeight: weight,
        color: AppColors.textPrimary,
      ),
    );
  }

}
