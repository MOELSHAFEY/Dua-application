import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'package:dua/core/di/injection_container.dart' as di;
import 'package:dua/core/theme/colors.dart';
import 'package:dua/core/entities/drug.dart';
import 'package:dua/features/favorites/presentation/providers/favorites_provider.dart';
import '../providers/drug_details_provider.dart';
import '../widgets/drug_product_image.dart';
import '../widgets/drug_ecommerce_header.dart';
import '../widgets/drug_info_card.dart';
import '../widgets/drug_action_buttons.dart';

class DrugDetailsScreen extends StatefulWidget {
  final Drug drug;
  const DrugDetailsScreen({super.key, required this.drug});

  @override
  State<DrugDetailsScreen> createState() => _DrugDetailsScreenState();
}

class _DrugDetailsScreenState extends State<DrugDetailsScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _shareDrug(String rawInfo) async {
    final drugInfo = rawInfo
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

    try {
      final screenWidth = MediaQuery.of(context).size.width;
      _showSnackBar("جاري تجهيز بيانات الدواء للمشاركة...");

      final directory = await getTemporaryDirectory();
      final imagePath =
          await File('${directory.path}/drug_${widget.drug.id}.png').create();

      if (widget.drug.image.contains("http")) {
        if (!mounted) return;
        final image = await screenshotController.captureFromLongWidget(
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Image.network(widget.drug.image, fit: BoxFit.contain),
          ),
          delay: const Duration(milliseconds: 200),
          context: context,
          constraints: BoxConstraints(
            maxWidth: screenWidth,
          ),
        );
        await imagePath.writeAsBytes(image);
      }

      final shareText =
          'اسم الدواء: ${widget.drug.name}\nالسعر: ${widget.drug.price} جنيه\n\nمعلومات الدواء:\n$drugInfo\n\nتطبيق دوا: https://t.me/elshafey_Team';

      if (await imagePath.exists() && await imagePath.length() > 0) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(imagePath.path)],
            text: shareText,
            subject: 'معلومات الدواء ${widget.drug.name}',
          ),
        );
      } else {
        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            subject: 'معلومات الدواء ${widget.drug.name}',
          ),
        );
      }
    } catch (e) {
      _showSnackBar("فشل في مشاركة الدواء", isError: true);
    }
  }

  void _openFullScreenImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: widget.drug.image.contains("http")
                  ? Image.network(
                      widget.drug.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.medication_outlined, size: 80, color: Colors.white54),
                    )
                  : const Icon(Icons.medication_outlined, size: 80, color: Colors.white54),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return ChangeNotifierProvider(
      create: (_) => di.sl<DrugDetailsProvider>()..loadDrugInfo(widget.drug.id),
      child: Consumer2<DrugDetailsProvider, FavoritesProvider>(
        builder: (context, drugProvider, favoritesProvider, child) {
          final isFavorite = favoritesProvider.isFavorite(widget.drug.id);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              appBar: AppBar(
                backgroundColor: AppColors.surface,
                elevation: 0,
                scrolledUnderElevation: 1,
                title: Text(
                  widget.drug.name,
                  style: GoogleFonts.cairo(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFavorite ? AppColors.error : AppColors.textSecondary,
                    ),
                    tooltip: isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                    onPressed: () => favoritesProvider.toggleFavorite(widget.drug),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary),
                    tooltip: 'مشاركة',
                    onPressed: () => _shareDrug(drugProvider.drugInfo),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
              body: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DrugProductImage(
                      drug: widget.drug,
                      onTap: () => _openFullScreenImage(context),
                    ),
                    DrugEcommerceHeader(
                      drug: widget.drug,
                      isTablet: isTablet,
                    ),
                    DrugActionButtons(
                      isFavorite: isFavorite,
                      onFavoriteToggle: () => favoritesProvider.toggleFavorite(widget.drug),
                    ),
                    const SizedBox(height: 8),
                    DrugInfoCard(
                      provider: drugProvider,
                      isTablet: isTablet,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
