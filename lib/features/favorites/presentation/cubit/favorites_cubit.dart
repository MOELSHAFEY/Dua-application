import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dua/core/usecases/usecase.dart';
import 'package:dua/core/entities/drug.dart';
import 'package:dua/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:dua/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:dua/features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import 'package:dua/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final FavoritesRepository repository;

  FavoritesCubit({
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
    required this.repository,
  }) : super(FavoritesInitial());

  Future<void> init() async {
    await repository.init();
    await loadFavorites();
  }

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    final result = await getFavoritesUseCase(NoParams());
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> toggleFavorite(Drug drug) async {
    final result = await toggleFavoriteUseCase(drug);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => loadFavorites(),
    );
  }

  bool isFavorite(String id) {
    return repository.isFavorite(id);
  }
}
