import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/core/entities/drug.dart';
import 'package:dua/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:dua/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:dua/features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import 'package:dua/features/favorites/presentation/providers/favorites_provider.dart';

class FakeFavoritesRepository implements FavoritesRepository {
  List<Drug> inMemoryFavorites = [];
  bool shouldFail = false;

  @override
  Future<Either<Failure, void>> init() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<Drug>>> getFavorites() async {
    if (shouldFail) return const Left(CacheFailure('Cache read failed'));
    return Right(List.from(inMemoryFavorites));
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(Drug drug) async {
    if (shouldFail) return const Left(CacheFailure('Cache write failed'));
    if (isFavorite(drug.id)) {
      inMemoryFavorites.removeWhere((d) => d.id == drug.id);
    } else {
      inMemoryFavorites.add(drug);
    }
    return const Right(null);
  }

  @override
  bool isFavorite(String id) {
    return inMemoryFavorites.any((d) => d.id == id);
  }
}

void main() {
  late FakeFavoritesRepository fakeRepository;
  late GetFavoritesUseCase getFavoritesUseCase;
  late ToggleFavoriteUseCase toggleFavoriteUseCase;
  late FavoritesProvider provider;

  const testDrug = Drug(
    id: '1',
    name: 'Panadol Extra',
    price: '30',
    image: 'https://img.png',
  );

  setUp(() {
    fakeRepository = FakeFavoritesRepository();
    getFavoritesUseCase = GetFavoritesUseCase(fakeRepository);
    toggleFavoriteUseCase = ToggleFavoriteUseCase(fakeRepository);
    provider = FavoritesProvider(
      getFavoritesUseCase: getFavoritesUseCase,
      toggleFavoriteUseCase: toggleFavoriteUseCase,
      repository: fakeRepository,
    );
  });

  test('initial state is correct', () {
    expect(provider.status, FavoritesStatus.initial);
    expect(provider.favorites, isEmpty);
  });

  test('loadFavorites updates state with list on success', () async {
    fakeRepository.inMemoryFavorites = [testDrug];

    await provider.loadFavorites();

    expect(provider.status, FavoritesStatus.loaded);
    expect(provider.isLoaded, isTrue);
    expect(provider.favorites.length, 1);
    expect(provider.favorites.first.name, 'Panadol Extra');
  });

  test('toggleFavorite adds then removes drug and updates state', () async {
    expect(provider.isFavorite(testDrug.id), isFalse);

    await provider.toggleFavorite(testDrug);
    expect(provider.favorites.length, 1);
    expect(provider.isFavorite(testDrug.id), isTrue);

    await provider.toggleFavorite(testDrug);
    expect(provider.favorites, isEmpty);
    expect(provider.isFavorite(testDrug.id), isFalse);
  });

  test('loadFavorites sets error status on failure', () async {
    fakeRepository.shouldFail = true;

    await provider.loadFavorites();

    expect(provider.status, FavoritesStatus.error);
    expect(provider.isError, isTrue);
    expect(provider.errorMessage, 'Cache read failed');
  });
}
