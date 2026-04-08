import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_version.dart';
import '../../domain/repositories/access_repository.dart';
import '../datasources/access_remote_data_source.dart';

class AccessRepositoryImpl implements AccessRepository {
  final AccessRemoteDataSource remoteDataSource;

  AccessRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AppVersion>> getLatestVersion() async {
    try {
      final remoteVersion = await remoteDataSource.getLatestVersion();
      return Right(remoteVersion);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure('مشكلة في الاتصال بالإنترنت'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
