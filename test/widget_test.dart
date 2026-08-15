import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dua/core/theme/themes.dart';
import 'package:dua/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:dua/features/settings/presentation/providers/settings_provider.dart';
import 'package:dua/features/splash/presentation/screens/splash_screen.dart';
import 'package:dua/features/app_info/presentation/screens/app_info_screen.dart';

class MockSettingsDataSource implements SettingsLocalDataSource {
  @override
  Future<void> init() async {}
  @override
  ThemeMode getThemeMode() => ThemeMode.light;
  @override
  Future<void> setThemeMode(ThemeMode mode) async {}
  @override
  double getFontSizeScale() => 1.0;
  @override
  Future<void> setFontSizeScale(double scale) async {}
  @override
  DateTime? getLastAccessVerification() => null;
  @override
  Future<void> setLastAccessVerification(DateTime timestamp) async {}
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('SplashScreen renders branding elements', (WidgetTester tester) async {
    final settings = SettingsProvider(MockSettingsDataSource());

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: settings,
        child: MaterialApp(
          theme: AppThemes.lightTheme,
          home: const SplashScreen(),
        ),
      ),
    );

    expect(find.text('Dua'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('دليلك الدوائي الشامل'), findsOneWidget);
  });

  testWidgets('AppInfoScreen renders app info and details', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.lightTheme,
        home: const AppInfoScreen(),
      ),
    );

    expect(find.text('عن التطبيق'), findsOneWidget);
    expect(find.text('دوا - Dua'), findsOneWidget);
    expect(find.text('حول التطبيق'), findsOneWidget);
    expect(find.text('الاصدار 6.0.0'), findsOneWidget);
  });
}
