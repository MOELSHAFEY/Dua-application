import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_version.dart';
import '../repositories/access_repository.dart';

class CheckVersionUseCase implements UseCase<AppVersion, NoParams> {
  final AccessRepository repository;

  CheckVersionUseCase(this.repository);

  @override
  Future<Either<Failure, AppVersion>> call(NoParams params) async {
    return await repository.getLatestVersion();
  }
}
