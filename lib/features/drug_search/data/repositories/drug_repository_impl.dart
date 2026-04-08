import 'package:dartz/dartz.dart';
import 'package:dua/core/error/exceptions.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/core/entities/drug.dart';
import '../../domain/repositories/drug_repository.dart';
import '../datasources/drug_remote_data_source.dart';

class DrugRepositoryImpl implements DrugRepository {
  final DrugRemoteDataSource remoteDataSource;

  DrugRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Drug>>> searchDrugs(String query) async {
    try {
      final remoteDrugs = await remoteDataSource.searchDrugs(query);
      return Right(remoteDrugs);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure('مشكلة في الاتصال بالإنترنت'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
