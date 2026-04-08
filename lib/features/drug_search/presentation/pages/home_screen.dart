import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import 'package:dua/core/theme/colors.dart';
import 'package:dua/core/widgets/empty_state_widget.dart';
import 'package:dua/core/widgets/enhanced_drug_card.dart';
import 'package:dua/core/widgets/shimmer_loading.dart';
import 'package:dua/features/favorites/presentation/pages/favorites_screen.dart';
import 'package:dua/features/drug_search/presentation/cubit/search_cubit.dart';
import 'package:dua/features/drug_search/presentation/cubit/search_state.dart';
import 'package:dua/features/drug_details/presentation/pages/drug_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildSearchScreen(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.medication_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Dua',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.favorite_rounded,
              color: AppColors.error,
            ),
            title: Text(
              'المفضلة',
              style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Moelshafey ©2026',
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchScreen() {
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state is SearchError) {
          _showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                   
                    _buildSearchField(),
                    const SizedBox(height: 32),
                    _buildResults(state),
                    
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildSearchField() {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              context.read<SearchCubit>().search(query);
            }
          },
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: 'ابحث عن اسم الدواء...',
            hintStyle: GoogleFonts.cairo(
              color: AppColors.textLight,
              fontSize: 16,
            ),
            prefixIcon: IconButton(
              icon: const Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: 28,
              ),
              onPressed: () {
                if (_searchController.text.trim().isNotEmpty) {
                  context.read<SearchCubit>().search(_searchController.text);
                }
              },
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.mic_none_rounded,
                color: AppColors.primary,
              ),
              onPressed: () {
                // Future implementation: Voice Search
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(SearchState state) {
    if (state is SearchInitial) {
      return _buildInitialState();
    } else if (state is SearchLoading) {
      return FadeIn(
        duration: const Duration(milliseconds: 300),
        child: const DrugListShimmer(),
      );
    } else if (state is SearchLoaded) {
      if (state.drugs.isEmpty) {
        return _buildEmptyState();
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.drugs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final drug = state.drugs[index];
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
    } else if (state is SearchError) {
      return _buildErrorState(state.message);
    }
    return const SizedBox.shrink();
  }

  Widget _buildInitialState() {
    return EmptyStateWidget(
      icon: Icons.search_rounded,
      title: 'ابحث عن دواء',
      subtitle:
          'استخدم شريط البحث أعلاه للعثور على معلومات الأدوية والأسعار البديلة.',
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.search_off_rounded,
      title: 'لا توجد نتائج',
      subtitle:
          'لم نتمكن من العثور على أي أدوية تطابق بحثك. حاول استخدام كلمات مفتاحية أخرى.',
    );
  }

  Widget _buildErrorState(String message) {
    return EmptyStateWidget(
      icon: Icons.error_outline_rounded,
      title: 'خطأ في البحث',
      subtitle: message,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.scaffoldBackground,
      elevation: 4,
      centerTitle: true,
      title: Text(
        'Dua',
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
          fontSize: 22,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_rounded, color: AppColors.error),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
            );
          },
        ),
      ],
    );
  }


  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
