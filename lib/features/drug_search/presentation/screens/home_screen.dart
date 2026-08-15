import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dua/core/theme/colors.dart';
import 'package:dua/core/widgets/empty_state_widget.dart';
import 'package:dua/core/widgets/enhanced_drug_card.dart';
import 'package:dua/core/widgets/shimmer_loading.dart';
import 'package:dua/features/settings/presentation/providers/settings_provider.dart';
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
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  bool _isListening = false;
  final VoiceSearchService _voiceSearchService = di.sl<VoiceSearchService>();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.dispose();
    _voiceSearchService.stopListening();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      context.read<SearchProvider>().clearSearch();
      setState(() {});
      return;
    }

    // 300ms Debounced live search
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _onPerformSearch(query);
    });
    setState(() {});
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildSearchScreen(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final settings = context.watch<SettingsProvider>();

    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
        // Text Size Toggle Button
        IconButton(
          icon: Icon(
            settings.isLargeText ? Icons.format_size_rounded : Icons.text_fields_rounded,
            size: 22,
          ),
          tooltip: settings.isLargeText ? 'خط عادي' : 'خط كبير',
          onPressed: () => settings.toggleTextSize(),
        ),

        // Dark/Light Theme Toggle Button
        IconButton(
          icon: Icon(
            settings.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
            size: 22,
          ),
          tooltip: settings.isDarkMode ? 'الوضع الفاتح' : 'الوضع الليلي',
          onPressed: () => settings.toggleTheme(context),
        ),

        // Favorites Button
        IconButton(
          icon: const Icon(Icons.favorite_border_rounded, color: AppColors.error),
          tooltip: 'المفضلة',
          onPressed: () {
            HapticFeedback.lightImpact();
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
    final settings = context.watch<SettingsProvider>();

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          SwitchListTile(
            secondary: Icon(
              settings.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: AppColors.primary,
            ),
            title: Text(
              'الوضع الليلي',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            value: settings.isDarkMode,
            activeColor: AppColors.primary,
            onChanged: (_) => settings.toggleTheme(context),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.format_size_rounded, color: AppColors.primary),
            title: Text(
              'تكبير حجم الخط',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            value: settings.isLargeText,
            activeColor: AppColors.primary,
            onChanged: (_) => settings.toggleTextSize(),
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
          color: Theme.of(context).colorScheme.onSurface,
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
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                child: Column(
                  children: [
                    _buildSearchField(),
                    if (_isListening) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'جاري الاستماع... تحدث الآن باسم الدواء',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
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
    final isFocused = _focusNode.hasFocus;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final borderColor = isFocused
        ? primaryColor
        : (isDark ? AppColors.borderDark : AppColors.border);
    final fieldBg = isFocused
        ? Theme.of(context).cardColor
        : (isDark ? AppColors.surfaceElevatedDark : AppColors.grey50);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
          width: isFocused ? 1.5 : 1.0,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Row(
        children: [
          // Search Icon & Submit Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                HapticFeedback.lightImpact();
                _onPerformSearch(_searchController.text);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isFocused
                      ? primaryColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: isFocused ? primaryColor : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),

          // Search Input Field
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onSubmitted: _onPerformSearch,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'ابحث باسم الدواء التجاري أو العلمي...',
                hintStyle: GoogleFonts.cairo(
                  color: AppColors.textLight,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                isDense: true,
              ),
            ),
          ),

          // Clear Button
          if (_searchController.text.isNotEmpty) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  HapticFeedback.lightImpact();
                  _searchController.clear();
                  context.read<SearchProvider>().clearSearch();
                  setState(() {});
                },
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: AppColors.border,
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ],

          // Voice Search Mic Button
          Material(
            color: Colors.transparent,
            child: Tooltip(
              message: _isListening ? 'إيقاف الاستماع' : 'بحث صوتي',
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: _toggleVoiceSearch,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isListening
                        ? AppColors.error
                        : (_focusNode.hasFocus ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                    color: _isListening
                        ? Colors.white
                        : (_focusNode.hasFocus ? AppColors.primary : AppColors.textSecondary),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleVoiceSearch() async {
    HapticFeedback.mediumImpact();
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
            searchQuery: _searchController.text,
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
      return _buildOfflineResilientError(provider.errorMessage);
    }

    return const SizedBox.shrink();
  }

  Widget _buildOfflineResilientError(String message) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Non-blocking Offline Resilience Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.wifi_off_rounded, color: AppColors.warning, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'تعذر الاتصال بالإنترنت',
                    style: GoogleFonts.cairo(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'أنت في وضع عدم الاتصال حالياً. يمكنك تصفح واستعراض الأدوية المحفوظة في قائمة المفضلة في أي وقت دون إنترنت.',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                    );
                  },
                  icon: const Icon(Icons.favorite_rounded, size: 16, color: Colors.white),
                  label: const Text('تصفح المفضلة المحفوظة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton.icon(
            onPressed: () => _onPerformSearch(_searchController.text),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(
              'إعادة المحاولة',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
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
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    historyProvider.clearHistory();
                  },
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onDeleted: () {
                    HapticFeedback.lightImpact();
                    historyProvider.removeSearch(item);
                  },
                  deleteIconColor: AppColors.textLight,
                  deleteIcon: const Icon(Icons.close_rounded, size: 14),
                  onPressed: () {
                    HapticFeedback.lightImpact();
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
}
