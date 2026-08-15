import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/features/access_control/domain/entities/app_version.dart';
import 'package:dua/features/access_control/domain/repositories/access_repository.dart';
import 'package:dua/features/access_control/domain/usecases/check_version_usecase.dart';
import 'package:dua/features/access_control/presentation/providers/access_provider.dart';

class FakeAccessRepository implements AccessRepository {
  Either<Failure, AppVersion>? result;

  @override
  Future<Either<Failure, AppVersion>> getLatestVersion() async {
    return result!;
  }
}

void main() {
  late FakeAccessRepository fakeRepository;
  late CheckVersionUseCase useCase;
  late AccessProvider provider;

  setUp(() {
    fakeRepository = FakeAccessRepository();
    useCase = CheckVersionUseCase(fakeRepository);
    provider = AccessProvider(checkVersionUseCase: useCase);
  });

  test('initial state is correct', () {
    expect(provider.status, AccessStatus.initial);
    expect(provider.isLoading, isFalse);
    expect(provider.isAuthorized, isFalse);
    expect(provider.isUpdateRequired, isFalse);
    expect(provider.isError, isFalse);
  });

  test('checkAccess sets authorized status when version matches current version', () async {
    fakeRepository.result = const Right(AppVersion(version: '5.0.0', url: 'https://update.url'));

    await provider.checkAccess();

    expect(provider.status, AccessStatus.authorized);
    expect(provider.isAuthorized, isTrue);
    expect(provider.isLoading, isFalse);
  });

  test('checkAccess sets updateRequired when version does not match', () async {
    fakeRepository.result = const Right(AppVersion(version: '5.1.0', url: 'https://update.url'));

    await provider.checkAccess();

    expect(provider.status, AccessStatus.updateRequired);
    expect(provider.isUpdateRequired, isTrue);
    expect(provider.updateUrl, 'https://update.url');
  });

  test('checkAccess sets error when failure occurs', () async {
    fakeRepository.result = const Left(ServerFailure('Connection error'));

    await provider.checkAccess();

    expect(provider.status, AccessStatus.error);
    expect(provider.isError, isTrue);
    expect(provider.errorMessage, 'Connection error');
  });
}
