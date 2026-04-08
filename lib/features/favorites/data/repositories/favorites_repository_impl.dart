import 'package:dartz/dartz.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/core/models/drug_model.dart';
import 'package:dua/core/entities/drug.dart';
import 'package:dua/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:dua/features/favorites/data/datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> init() async {
    try {
      await localDataSource.init();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Drug>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites.cast<Drug>());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(Drug drug) async {
    try {
      final drugModel = DrugModel(
        id: drug.id,
        name: drug.name,
        price: drug.price,
        image: drug.image,
        info: drug.info,
      );
      await localDataSource.toggleFavorite(drugModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  bool isFavorite(String id) {
    return localDataSource.isFavorite(id);
  }
}
