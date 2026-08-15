import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../drug_search/presentation/screens/home_screen.dart';
import '../providers/access_provider.dart';

class CheckAccessScreen extends StatefulWidget {
  const CheckAccessScreen({super.key});

  @override
  State<CheckAccessScreen> createState() => _CheckAccessScreenState();
}

class _CheckAccessScreenState extends State<CheckAccessScreen> {
  AccessStatus? _lastHandledStatus;

  void _handleStatusChange(BuildContext context, AccessProvider provider) {
    if (_lastHandledStatus == provider.status) return;
    _lastHandledStatus = provider.status;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (provider.isAuthorized) {
        context.read<SettingsProvider>().cacheAccessVerification();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (provider.isUpdateRequired) {
        _showUpdateDialog(context, provider.updateUrl);
      } else if (provider.isError) {
        _showErrorDialog(context, provider.errorMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ChangeNotifierProvider(
      create: (_) => di.sl<AccessProvider>()..checkAccess(),
      child: Consumer<AccessProvider>(
        builder: (context, provider, child) {
          _handleStatusChange(context, provider);

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified_user_outlined,
                          color: primaryColor,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'التحقق من الاتصال',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'جاري الاتصال بالخادم والتحقق من التحديثات...',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 36),
                      const CustomLoader(size: 32),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUpdateDialog(BuildContext ctx, String updateUrl) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => _AppDialog(
        icon: Icons.system_update_rounded,
        title: "تحديث جديد متوفر",
        message: "يتوفر إصدار أحدث من التطبيق. يرجى التحديث للمتابعة والاستفادة من أحدث الميزات.",
        buttonText: "تحديث الآن",
        onPressed: () async {
          final uri = Uri.parse(updateUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }

  void _showErrorDialog(BuildContext ctx, String message) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => _AppDialog(
        icon: Icons.cloud_off_rounded,
        title: "تعذر الاتصال",
        message: message.isNotEmpty ? message : "يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.",
        buttonText: "إعادة المحاولة",
        onPressed: () {
          Navigator.pop(ctx);
          _lastHandledStatus = null;
          ctx.read<AccessProvider>().checkAccess();
        },
      ),
    );
  }
}

class _AppDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const _AppDialog({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        title: Row(
          children: [
            Icon(icon, size: 24, color: primaryColor),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                buttonText,
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
}
