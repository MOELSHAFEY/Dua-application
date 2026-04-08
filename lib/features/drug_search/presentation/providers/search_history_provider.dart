import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SearchHistoryProvider extends ChangeNotifier {
  static const String _boxName = 'search_history';
  static const int _maxHistory = 20;

  Box<String>? _box;
  List<String> _history = [];

  List<String> get history => List.unmodifiable(_history);

  Future<void> initHive() async {
    try {
      _box = await Hive.openBox<String>(_boxName);
      _history = _box!.values.toList().reversed.toList();
      notifyListeners();
    } catch (_) {
      _history = [];
    }
  }

  Future<void> addSearch(String query) async {
    if (query.trim().isEmpty) return;
    _history.remove(query);
    _history.insert(0, query);
    if (_history.length > _maxHistory) {
      _history = _history.sublist(0, _maxHistory);
    }
    await _box?.clear();
    for (final item in _history.reversed) {
      await _box?.add(item);
    }
    notifyListeners();
  }

  Future<void> removeSearch(String query) async {
    _history.remove(query);
    await _syncBox();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history = [];
    await _box?.clear();
    notifyListeners();
  }

  Future<void> _syncBox() async {
    await _box?.clear();
    for (final item in _history.reversed) {
      await _box?.add(item);
    }
  }
}
