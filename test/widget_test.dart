import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dua/core/theme/themes.dart';
import 'package:dua/features/splash/presentation/screens/splash_screen.dart';
import 'package:dua/features/app_info/presentation/screens/app_info_screen.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('SplashScreen renders branding elements', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.lightTheme,
        home: const SplashScreen(),
      ),
    );

    expect(find.text('Dua'), findsWidgets);
    // Flush all animate_do delay timers (max delay 1500ms)
    await tester.pump(const Duration(milliseconds: 2000));
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
    expect(find.text('الاصدار 5.0.0'), findsOneWidget);
  });
}
