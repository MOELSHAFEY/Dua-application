import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_version.dart';

abstract class AccessRepository {
  Future<Either<Failure, AppVersion>> getLatestVersion();
}
