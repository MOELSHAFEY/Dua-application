import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/themes.dart';
import 'package:dua/features/settings/presentation/providers/settings_provider.dart';
import 'package:dua/features/drug_search/presentation/providers/search_provider.dart';
import 'package:dua/features/drug_search/presentation/providers/search_history_provider.dart';
import 'package:dua/features/favorites/presentation/providers/favorites_provider.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<SettingsProvider>()..init()),
        ChangeNotifierProvider(create: (_) => di.sl<FavoritesProvider>()..init()),
        ChangeNotifierProvider(create: (_) => di.sl<SearchProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<SearchHistoryProvider>()..initHive()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Dua',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: settings.themeMode,
            locale: const Locale('ar', 'EG'),
            supportedLocales: const [
              Locale('ar', 'EG'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(settings.fontSizeScale),
                ),
                child: child!,
              );
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
