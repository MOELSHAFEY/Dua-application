import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class SettingsLocalDataSource {
  Future<void> init();
  ThemeMode getThemeMode();
  Future<void> setThemeMode(ThemeMode mode);
  double getFontSizeScale();
  Future<void> setFontSizeScale(double scale);
  DateTime? getLastAccessVerification();
  Future<void> setLastAccessVerification(DateTime timestamp);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String boxName = 'app_settings_box';
  static const String themeKey = 'theme_mode';
  static const String fontScaleKey = 'font_scale';
  static const String lastAccessKey = 'last_access_verification';

  Box? _box;

  @override
  Future<void> init() async {
    _box = await Hive.openBox(boxName);
  }

  Box get box {
    if (_box == null || !_box!.isOpen) {
      throw StateError('Settings box is not initialized');
    }
    return _box!;
  }

  @override
  ThemeMode getThemeMode() {
    final raw = box.get(themeKey, defaultValue: 'system');
    switch (raw) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    String value = 'system';
    if (mode == ThemeMode.dark) value = 'dark';
    if (mode == ThemeMode.light) value = 'light';
    await box.put(themeKey, value);
  }

  @override
  double getFontSizeScale() {
    return (box.get(fontScaleKey, defaultValue: 1.0) as num).toDouble();
  }

  @override
  Future<void> setFontSizeScale(double scale) async {
    await box.put(fontScaleKey, scale);
  }

  @override
  DateTime? getLastAccessVerification() {
    final raw = box.get(lastAccessKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }

  @override
  Future<void> setLastAccessVerification(DateTime timestamp) async {
    await box.put(lastAccessKey, timestamp.toIso8601String());
  }
}
