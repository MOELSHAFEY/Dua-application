import 'package:hive_flutter/hive_flutter.dart';
import 'package:dua/core/models/drug_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<DrugModel>> getFavorites();
  Future<void> toggleFavorite(DrugModel drug);
  bool isFavorite(String id);
  Future<void> init();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String _boxName = 'favorites';
  Box<Map>? _box;

  @override
  Future<void> init() async {
    _box = await Hive.openBox<Map>(_boxName);
  }

  @override
  Future<List<DrugModel>> getFavorites() async {
    if (_box == null) await init();
    return _box!.values.map((e) => DrugModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  @override
  Future<void> toggleFavorite(DrugModel drug) async {
    if (_box == null) await init();
    if (isFavorite(drug.id)) {
      final key = _box!.keys.firstWhere((k) {
        final d = _box!.get(k);
        return d != null && (d['id'].toString() == drug.id);
      }, orElse: () => null);
      await _box!.delete(key);
    } else {
      await _box!.add(drug.toJson());
    }
  }

  @override
  bool isFavorite(String id) {
    if (_box == null) return false;
    return _box!.values.any((d) => d['id'].toString() == id);
  }
}
