import 'package:dartz/dartz.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/core/entities/drug.dart';

abstract class DrugRepository {
  Future<Either<Failure, List<Drug>>> searchDrugs(String query);
}
