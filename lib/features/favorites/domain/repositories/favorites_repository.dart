import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import 'package:dua/core/entities/drug.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Drug>>> getFavorites();
  Future<Either<Failure, void>> toggleFavorite(Drug drug);
  bool isFavorite(String id);
  Future<Either<Failure, void>> init();
}
