import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dua/core/theme/colors.dart';
import 'package:dua/core/widgets/empty_state_widget.dart';
import 'package:dua/core/widgets/enhanced_drug_card.dart';
import 'package:dua/core/widgets/shimmer_loading.dart';
import 'package:dua/features/app_info/presentation/screens/app_info_screen.dart';
import 'package:dua/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:dua/features/drug_details/presentation/screens/drug_details_screen.dart';
import 'package:dua/core/services/voice_search_service.dart';
import 'package:dua/core/di/injection_container.dart' as di;
import '../providers/search_provider.dart';
import '../providers/search_history_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isListening = false;
  final VoiceSearchService _voiceSearchService = di.sl<VoiceSearchService>();

  @override
  void dispose() {
    _voiceSearchService.stopListening();
    _searchController.dispose();
    super.dispose();
  }

  void _onPerformSearch(String query) {
    if (query.trim().isNotEmpty) {
      context.read<SearchProvider>().search(query);
      context.read<SearchHistoryProvider>().addSearch(query.trim());
    }
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      title: Text(
        'دوا',
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border_rounded, color: AppColors.error),
          tooltip: 'المفضلة',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
            );
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
            width: double.infinity,
            color: AppColors.primary,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.medication_rounded,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'دوا - Dua',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'دليلك الدوائي الشامل',
                    style: GoogleFonts.cairo(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildDrawerItem(
            icon: Icons.favorite_outline_rounded,
            title: 'الأدوية المفضلة',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.info_outline_rounded,
            title: 'عن التطبيق',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppInfoScreen()),
              );
            },
          ),
          const Spacer(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الإصدار 5.0.0',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                Text(
                  'Moelshafey © 2026',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(
        title,
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontSize: 15,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 13,
        color: AppColors.textLight,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSearchScreen() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, _) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: _buildSearchField(),
              ),
              Expanded(
                child: _buildResults(searchProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onSubmitted: _onPerformSearch,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: GoogleFonts.cairo(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'ابحث بالاسم التجاري أو المادة الفعالة...',
        hintStyle: GoogleFonts.cairo(
          color: AppColors.textLight,
          fontSize: 14,
        ),
        filled: true,
        fillColor: AppColors.grey50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        prefixIcon: IconButton(
          icon: Icon(
            _isListening ? Icons.mic : Icons.mic_none_rounded,
            color: _isListening ? AppColors.error : AppColors.primary,
          ),
          tooltip: 'بحث صوتي',
          onPressed: _toggleVoiceSearch,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textLight),
                onPressed: () {
                  _searchController.clear();
                  context.read<SearchProvider>().clearSearch();
                  setState(() {});
                },
              ),
            IconButton(
              icon: const Icon(Icons.search_rounded, color: AppColors.primary),
              onPressed: () => _onPerformSearch(_searchController.text),
            ),
          ],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      onChanged: (val) {
        if (val.isEmpty) {
          context.read<SearchProvider>().clearSearch();
        }
        setState(() {});
      },
    );
  }

  void _toggleVoiceSearch() async {
    if (_isListening) {
      await _voiceSearchService.stopListening();
      setState(() => _isListening = false);
    } else {
      bool available = await _voiceSearchService.initialize();
      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'التعرف الصوتي غير متوفر على هذا الجهاز',
                style: GoogleFonts.cairo(),
              ),
            ),
          );
        }
        return;
      }
      setState(() => _isListening = true);
      await _voiceSearchService.startListening(
        onResult: (text) {
          setState(() {
            _searchController.text = text;
            _isListening = false;
          });
          _onPerformSearch(text);
        },
        onListeningStateChanged: (listening) {
          setState(() => _isListening = listening);
        },
      );
    }
  }

  Widget _buildResults(SearchProvider provider) {
    if (provider.isLoading) {
      return const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: DrugListShimmer(),
      );
    }

    if (provider.isInitial) {
      return _buildInitialState();
    }

    if (provider.isLoaded) {
      if (provider.drugs.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: provider.drugs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final drug = provider.drugs[index];
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
      return _buildErrorState(provider.errorMessage);
    }

    return const SizedBox.shrink();
  }

  Widget _buildInitialState() {
    return Consumer<SearchHistoryProvider>(
      builder: (context, historyProvider, _) {
        final history = historyProvider.history;
        if (history.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.search_rounded,
            title: 'ابحث عن أي دواء',
            subtitle: 'اكتب اسم الدواء التجاري أو العلمي لمعرفة الأسعار والبدائل المتاحة',
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عمليات البحث الأخيرة',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () => historyProvider.clearHistory(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'مسح السجل',
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: history.map((item) {
                return InputChip(
                  label: Text(item),
                  labelStyle: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onDeleted: () => historyProvider.removeSearch(item),
                  deleteIconColor: AppColors.textLight,
                  deleteIcon: const Icon(Icons.close_rounded, size: 14),
                  onPressed: () {
                    _searchController.text = item;
                    _onPerformSearch(item);
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const EmptyStateWidget(
      icon: Icons.search_off_rounded,
      title: 'لم يتم العثور على نتائج',
      subtitle: 'تأكد من كتابة اسم الدواء بشكل صحيح، أو ابحث باسم المادة الفعالة',
    );
  }

  Widget _buildErrorState(String message) {
    return EmptyStateWidget(
      icon: Icons.wifi_off_rounded,
      title: 'خطأ في جلب البيانات',
      subtitle: message.isNotEmpty ? message : 'تعذر تحميل بيانات الأدوية. يرجى المحاولة مرة أخرى.',
      action: ElevatedButton.icon(
        onPressed: () => _onPerformSearch(_searchController.text),
        icon: const Icon(Icons.refresh_rounded, size: 18),
        label: const Text('إعادة المحاولة'),
      ),
    );
  }
}
