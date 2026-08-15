import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../../../drug_search/presentation/screens/home_screen.dart';
import '../providers/access_provider.dart';

class CheckAccessScreen extends StatefulWidget {
  const CheckAccessScreen({super.key});

  @override
  State<CheckAccessScreen> createState() => _CheckAccessScreenState();
}

class _CheckAccessScreenState extends State<CheckAccessScreen> {
  AccessStatus? _lastHandledStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AccessProvider>().checkAccess();
      }
    });
  }

  void _handleStatusChange(AccessProvider provider) {
    if (_lastHandledStatus == provider.status) return;
    _lastHandledStatus = provider.status;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (provider.isAuthorized) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (provider.isUpdateRequired) {
        _showUpdateDialog(provider.updateUrl);
      } else if (provider.isError) {
        _showErrorDialog(provider.errorMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessProvider>(
      builder: (context, provider, child) {
        _handleStatusChange(provider);

        return Scaffold(
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryDark,
                  AppColors.primary,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -100,
                  right: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 800),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Icon(
                            Icons.security_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          'تحقق من الوصول الآمن',
                          style: GoogleFonts.cairo(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeInUp(
                        duration: const Duration(milliseconds: 700),
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          'جاري تأمين اتصالك بالخادم...',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      const CustomLoader(size: 50, primaryColor: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUpdateDialog(String updateUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AppDialog(
        icon: Icons.system_update_alt,
        title: "تحديث مطلوب",
        message: "للاستمرار، يرجى تحديث التطبيق إلى أحدث إصدار.",
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AppDialog(
        icon: Icons.wifi_off,
        title: "مشكلة اتصال",
        message: message,
        buttonText: "إعادة المحاولة",
        onPressed: () {
          Navigator.pop(context);
          _lastHandledStatus = null;
          context.read<AccessProvider>().checkAccess();
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Icon(icon, size: 48, color: AppColors.primary)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
