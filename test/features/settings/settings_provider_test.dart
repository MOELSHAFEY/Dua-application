import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dua/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:dua/features/settings/presentation/providers/settings_provider.dart';

class MockSettingsLocalDataSource implements SettingsLocalDataSource {
  ThemeMode themeMode = ThemeMode.system;
  double fontScale = 1.0;
  DateTime? lastVerification;

  @override
  Future<void> init() async {}

  @override
  ThemeMode getThemeMode() => themeMode;

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
  }

  @override
  double getFontSizeScale() => fontScale;

  @override
  Future<void> setFontSizeScale(double scale) async {
    fontScale = scale;
  }

  @override
  DateTime? getLastAccessVerification() => lastVerification;

  @override
  Future<void> setLastAccessVerification(DateTime timestamp) async {
    lastVerification = timestamp;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SettingsProvider provider;
  late MockSettingsLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockSettingsLocalDataSource();
    provider = SettingsProvider(mockDataSource);
  });

  test('initial values are correct before init', () {
    expect(provider.themeMode, ThemeMode.system);
    expect(provider.fontSizeScale, 1.0);
    expect(provider.isLargeText, false);
    expect(provider.isDarkMode, false);
    expect(provider.isInitialized, false);
  });

  test('init loads values from data source', () async {
    mockDataSource.themeMode = ThemeMode.dark;
    mockDataSource.fontScale = 1.25;

    await provider.init();

    expect(provider.themeMode, ThemeMode.dark);
    expect(provider.fontSizeScale, 1.25);
    expect(provider.isLargeText, true);
    expect(provider.isDarkMode, true);
    expect(provider.isInitialized, true);
  });

  test('toggleTextSize flips between 1.0 and 1.25', () async {
    await provider.init();
    expect(provider.isLargeText, false);

    await provider.toggleTextSize();
    expect(provider.fontSizeScale, 1.25);
    expect(provider.isLargeText, true);
    expect(mockDataSource.fontScale, 1.25);

    await provider.toggleTextSize();
    expect(provider.fontSizeScale, 1.0);
    expect(provider.isLargeText, false);
    expect(mockDataSource.fontScale, 1.0);
  });

  test('setThemeMode updates themeMode', () async {
    await provider.init();
    await provider.setThemeMode(ThemeMode.dark);

    expect(provider.themeMode, ThemeMode.dark);
    expect(mockDataSource.themeMode, ThemeMode.dark);
  });

  test('isAccessVerificationValid returns true if within 24 hours and false otherwise', () async {
    expect(provider.isAccessVerificationValid(), false);

    mockDataSource.lastVerification = DateTime.now().subtract(const Duration(hours: 5));
    expect(provider.isAccessVerificationValid(), true);

    mockDataSource.lastVerification = DateTime.now().subtract(const Duration(hours: 25));
    expect(provider.isAccessVerificationValid(), false);
  });

  test('cacheAccessVerification saves timestamp', () async {
    await provider.cacheAccessVerification();
    expect(mockDataSource.lastVerification, isNotNull);
    expect(provider.isAccessVerificationValid(), true);
  });
}
