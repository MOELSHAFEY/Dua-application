import 'package:dartz/dartz.dart';
import 'package:dua/core/error/exceptions.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/features/drug_details/domain/repositories/drug_details_repository.dart';
import 'package:dua/features/drug_details/data/datasources/drug_details_remote_data_source.dart';

class DrugDetailsRepositoryImpl implements DrugDetailsRepository {
  final DrugDetailsRemoteDataSource remoteDataSource;

  DrugDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> getDrugInfo(String id) async {
    try {
      final info = await remoteDataSource.getDrugInfo(id);
      return Right(info);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure('مشكلة في الاتصال بالإنترنت'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
