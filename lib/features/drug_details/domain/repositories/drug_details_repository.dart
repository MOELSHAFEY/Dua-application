import 'package:dartz/dartz.dart';
import 'package:dua/core/error/failures.dart';

abstract class DrugDetailsRepository {
  Future<Either<Failure, String>> getDrugInfo(String id);
}
