import 'package:flutter/foundation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/entities/drug.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

enum FavoritesStatus {
  initial,
  loading,
  loaded,
  error,
}

class FavoritesProvider extends ChangeNotifier {
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final FavoritesRepository repository;

  FavoritesStatus _status = FavoritesStatus.initial;
  List<Drug> _favorites = [];
  String _errorMessage = '';

  FavoritesProvider({
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
    required this.repository,
  });

  FavoritesStatus get status => _status;
  bool get isLoading => _status == FavoritesStatus.loading;
  bool get isLoaded => _status == FavoritesStatus.loaded;
  bool get isError => _status == FavoritesStatus.error;
  List<Drug> get favorites => List.unmodifiable(_favorites);
  String get errorMessage => _errorMessage;

  Future<void> init() async {
    await repository.init();
    await loadFavorites();
  }

  Future<void> loadFavorites() async {
    _status = FavoritesStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await getFavoritesUseCase(NoParams());
    result.fold(
      (failure) {
        _status = FavoritesStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (favoritesList) {
        _status = FavoritesStatus.loaded;
        _favorites = favoritesList;
        notifyListeners();
      },
    );
  }

  Future<void> toggleFavorite(Drug drug) async {
    final result = await toggleFavoriteUseCase(drug);
    await result.fold(
      (failure) async {
        _status = FavoritesStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (_) async => await loadFavorites(),
    );
  }

  bool isFavorite(String id) {
    return repository.isFavorite(id);
  }
}
