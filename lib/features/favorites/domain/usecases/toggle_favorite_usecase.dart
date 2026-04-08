import 'package:dartz/dartz.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/core/usecases/usecase.dart';
import 'package:dua/core/entities/drug.dart';
import 'package:dua/features/favorites/domain/repositories/favorites_repository.dart';

class ToggleFavoriteUseCase implements UseCase<void, Drug> {
  final FavoritesRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Drug params) async {
    return await repository.toggleFavorite(params);
  }
}
