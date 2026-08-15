import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dua/core/theme/colors.dart';
import 'package:dua/core/widgets/custom_loader.dart';
import 'package:dua/core/widgets/empty_state_widget.dart';
import 'package:dua/core/widgets/enhanced_drug_card.dart';
import 'package:dua/features/drug_details/presentation/screens/drug_details_screen.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'الأدوية المفضلة',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Consumer<FavoritesProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CustomLoader(size: 32));
            }

            if (provider.isLoaded) {
              final favorites = provider.favorites;

              if (favorites.isEmpty) {
                return const EmptyStateWidget(
                  icon: Icons.favorite_border_rounded,
                  title: 'قائمة المفضلة فارغة',
                  subtitle: 'يمكنك حفظ الأدوية المهمة بالضغط على رمز القلب في شاشة تفاصيل الدواء',
                );
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final drug = favorites[index];
                  return EnhancedDrugCard(
                    drug: drug,
                    index: index,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DrugDetailsScreen(drug: drug),
                        ),
                      );
                    },
                  );
                },
              );
            }

            if (provider.isError) {
              return Center(
                child: Text(
                  provider.errorMessage,
                  style: GoogleFonts.cairo(color: AppColors.error),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
