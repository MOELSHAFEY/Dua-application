import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'package:dua/core/di/injection_container.dart';
import 'package:dua/core/theme/colors.dart';
import 'package:dua/core/entities/drug.dart';
import 'package:dua/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dua/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:dua/features/drug_details/presentation/cubit/drug_details_cubit.dart';
import 'package:dua/features/drug_details/presentation/cubit/drug_details_state.dart';
import 'package:dua/features/drug_details/presentation/widgets/drug_product_image.dart';
import 'package:dua/features/drug_details/presentation/widgets/drug_ecommerce_header.dart';
import 'package:dua/features/drug_details/presentation/widgets/drug_info_card.dart';
import 'package:dua/features/drug_details/presentation/widgets/drug_action_buttons.dart';

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
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _shareDrug(String rawInfo) async {
    final drugInfo =
        rawInfo
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
      _showSnackBar("جاري تجهيز الصورة للمشاركة...");

      final image = await screenshotController.captureFromLongWidget(
        Container(
          color: Colors.white,
          child:
              widget.drug.image.contains("http")
                  ? Image.network(widget.drug.image, fit: BoxFit.contain)
                  : Container(
                    height: 300,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: Center(
                      child: Icon(
                        Icons.medication_rounded,
                        size: 100,
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
        ),
        delay: const Duration(milliseconds: 300),
        context: context,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
      );

      final directory = await getTemporaryDirectory();
      final imagePath =
          await File('${directory.path}/drug_${widget.drug.id}.png').create();
      await imagePath.writeAsBytes(image);

      final shareText =
          'اسم الدواء: ${widget.drug.name}\n\nالسعر: ${widget.drug.price} جنيه\n\nالتفاصيل :${drugInfo}\n\n لتحميل التطبيق من هنا : https://t.me/elshafey_Team';

      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text: shareText,
        subject: 'معلومات الدواء ${widget.drug.name}',
      );
    } catch (e) {
      _showSnackBar("فشل في مشاركة الدواء", isError: true);
    }
  }

  void _openFullScreenImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder:
            (context) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Hero(
                    tag: 'drug_img_${widget.drug.id}',
                    child:
                        widget.drug.image.contains("http")
                            ? Image.network(
                              widget.drug.image,
                              fit: BoxFit.contain,
                            )
                            : Container(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              child: Center(
                                child: Icon(
                                  Icons.medication_rounded,
                                  size: 100,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                            ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DrugDetailsCubit>()..loadDrugInfo(widget.drug.id),
      child: BlocBuilder<DrugDetailsCubit, DrugDetailsState>(
        builder: (context, state) {
          return BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (fContext, fState) {
              final isFav = context.read<FavoritesCubit>().isFavorite(
                widget.drug.id,
              );

              return Scaffold(
                backgroundColor: AppColors.scaffoldBackground,
                appBar: _buildAppBar(isFav, state),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth > 600;

                    return SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DrugProductImage(
                            drug: widget.drug,
                            onTap: () => _openFullScreenImage(context),
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    isTablet ? constraints.maxWidth * 0.1 : 0,
                              ),
                              child: Column(
                                children: [
                                  DrugEcommerceHeader(
                                    drug: widget.drug,
                                    isTablet: isTablet,
                                  ),
                                  const SizedBox(height: 16),
                                  DrugInfoCard(
                                    state: state,
                                    isTablet: isTablet,
                                  ),
                                  const SizedBox(height: 24),
                                  DrugActionButtons(
                                    isFavorite: isFav,
                                    onFavoriteToggle: () {
                                      context
                                          .read<FavoritesCubit>()
                                          .toggleFavorite(widget.drug);
                                      _showSnackBar(
                                        isFav
                                            ? "تمت الإزالة من المفضلة"
                                            : "تمت الإضافة إلى المفضلة",
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isFavorite, DrugDetailsState state) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'التفاصيل',
        style: GoogleFonts.cairo(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.primaryDark,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            final rawInfo = state is DrugDetailsLoaded ? state.info : '';
            _shareDrug(rawInfo);
          },
          icon: const Icon(Icons.share_rounded, color: AppColors.primaryDark),
        ),
        IconButton(
          onPressed: () {
            context.read<FavoritesCubit>().toggleFavorite(widget.drug);
            _showSnackBar(
              isFavorite ? "تمت الإزالة من المفضلة" : "تمت الإضافة إلى المفضلة",
            );
          },
          icon: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFavorite ? AppColors.error : AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}
