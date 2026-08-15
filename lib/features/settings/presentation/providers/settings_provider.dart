import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/datasources/settings_local_data_source.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsLocalDataSource _dataSource;

  ThemeMode _themeMode = ThemeMode.system;
  double _fontSizeScale = 1.0;
  bool _isInitialized = false;

  SettingsProvider(this._dataSource);

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  double get fontSizeScale => _fontSizeScale;
  bool get isLargeText => _fontSizeScale > 1.1;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    try {
      await _dataSource.init();
      _themeMode = _dataSource.getThemeMode();
      _fontSizeScale = _dataSource.getFontSizeScale();
      _isInitialized = true;
      notifyListeners();
    } catch (_) {
      _isInitialized = true;
    }
  }

  Future<void> toggleTheme(BuildContext context) async {
    HapticFeedback.lightImpact();
    final isCurrentDark = _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    _themeMode = isCurrentDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await _dataSource.setThemeMode(_themeMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _dataSource.setThemeMode(mode);
  }

  Future<void> toggleTextSize() async {
    HapticFeedback.lightImpact();
    _fontSizeScale = isLargeText ? 1.0 : 1.25;
    notifyListeners();
    await _dataSource.setFontSizeScale(_fontSizeScale);
  }

  Future<void> setFontSizeScale(double scale) async {
    _fontSizeScale = scale;
    notifyListeners();
    await _dataSource.setFontSizeScale(scale);
  }

  Future<void> cacheAccessVerification() async {
    await _dataSource.setLastAccessVerification(DateTime.now());
  }

  bool isAccessVerificationValid() {
    try {
      final lastVerification = _dataSource.getLastAccessVerification();
      if (lastVerification == null) return false;
      final difference = DateTime.now().difference(lastVerification);
      return difference.inHours < 24;
    } catch (_) {
      return false;
    }
  }
}
