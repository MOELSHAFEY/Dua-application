import 'package:dartz/dartz.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/core/usecases/usecase.dart';
import 'package:dua/core/entities/drug.dart';
import 'package:dua/features/favorites/domain/repositories/favorites_repository.dart';

class GetFavoritesUseCase implements UseCase<List<Drug>, NoParams> {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Drug>>> call(NoParams params) async {
    return await repository.getFavorites();
  }
}
