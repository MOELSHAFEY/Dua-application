import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dua/core/theme/colors.dart';
import 'package:dua/core/widgets/custom_loading_indicator.dart';
import 'package:dua/core/widgets/empty_state_widget.dart';
import 'package:dua/core/widgets/enhanced_drug_card.dart';
import 'package:dua/features/drug_details/presentation/pages/drug_details_screen.dart';
import 'package:dua/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dua/features/favorites/presentation/cubit/favorites_state.dart';

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
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CustomLoadingIndicator());
          }

          if (state is FavoritesLoaded) {
            final favorites = state.favorites;

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

          if (state is FavoritesError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
