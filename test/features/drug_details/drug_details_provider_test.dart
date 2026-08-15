import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/features/drug_details/domain/repositories/drug_details_repository.dart';
import 'package:dua/features/drug_details/domain/usecases/get_drug_info_usecase.dart';
import 'package:dua/features/drug_details/presentation/providers/drug_details_provider.dart';

class FakeDrugDetailsRepository implements DrugDetailsRepository {
  Either<Failure, String>? result;

  @override
  Future<Either<Failure, String>> getDrugInfo(String id) async {
    return result!;
  }
}

void main() {
  late FakeDrugDetailsRepository fakeRepository;
  late GetDrugInfoUseCase useCase;
  late DrugDetailsProvider provider;

  setUp(() {
    fakeRepository = FakeDrugDetailsRepository();
    useCase = GetDrugInfoUseCase(fakeRepository);
    provider = DrugDetailsProvider(getDrugInfoUseCase: useCase);
  });

  test('initial state is correct', () {
    expect(provider.status, DrugDetailsStatus.initial);
    expect(provider.drugInfo, isEmpty);
    expect(provider.isLoading, isFalse);
  });

  test('loadDrugInfo sets loaded state with formatted info on success', () async {
    fakeRepository.result = const Right('<p>Paracetamol 500mg used for headache relief</p>');

    await provider.loadDrugInfo('123');

    expect(provider.status, DrugDetailsStatus.loaded);
    expect(provider.isLoaded, isTrue);
    expect(provider.drugInfo, '<p>Paracetamol 500mg used for headache relief</p>');
  });

  test('loadDrugInfo sets error state on failure', () async {
    fakeRepository.result = const Left(ServerFailure('Drug not found'));

    await provider.loadDrugInfo('999');

    expect(provider.status, DrugDetailsStatus.error);
    expect(provider.isError, isTrue);
    expect(provider.errorMessage, 'Drug not found');
  });

  test('dispose flag stops state updates when disposed', () async {
    provider.dispose();
    fakeRepository.result = const Right('Info');

    await provider.loadDrugInfo('123');
    // Does not throw and does not notify
    expect(provider.drugInfo, isEmpty);
  });
}
