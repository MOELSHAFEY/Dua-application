import 'package:dartz/dartz.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/core/usecases/usecase.dart';
import 'package:dua/core/entities/drug.dart';
import '../repositories/drug_repository.dart';

class SearchDrugsUseCase implements UseCase<List<Drug>, String> {
  final DrugRepository repository;

  SearchDrugsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Drug>>> call(String params) async {
    return await repository.searchDrugs(params);
  }
}
