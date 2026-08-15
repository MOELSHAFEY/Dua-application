import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dua/core/theme/colors.dart';
import 'package:dua/core/widgets/custom_loading_indicator.dart';
import 'package:dua/core/widgets/empty_state_widget.dart';
import 'package:dua/core/widgets/enhanced_drug_card.dart';
import 'package:dua/features/drug_details/presentation/screens/drug_details_screen.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'المفضلة',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CustomLoadingIndicator());
          }

          if (provider.isLoaded) {
            final favorites = provider.favorites;

            if (favorites.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.favorite_border,
                title: 'لا توجد أدوية في المفضلة',
                subtitle: 'ابحث عن الأدوية وأضفها إلى المفضلة لتسهيل الوصول إليها لاحقاً',
              );
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final drug = favorites[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: EnhancedDrugCard(
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
                  ),
                );
              },
            );
          }

          if (provider.isError) {
            return Center(child: Text(provider.errorMessage));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
