import 'package:dartz/dartz.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/core/usecases/usecase.dart';
import 'package:dua/features/drug_details/domain/repositories/drug_details_repository.dart';

class GetDrugInfoUseCase implements UseCase<String, String> {
  final DrugDetailsRepository repository;

  GetDrugInfoUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await repository.getDrugInfo(params);
  }
}
