import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dua/core/error/failures.dart';
import 'package:dua/core/entities/drug.dart';
import 'package:dua/features/drug_search/domain/repositories/drug_repository.dart';
import 'package:dua/features/drug_search/domain/usecases/search_drugs_usecase.dart';
import 'package:dua/features/drug_search/presentation/providers/search_provider.dart';

class FakeDrugRepository implements DrugRepository {
  Either<Failure, List<Drug>>? result;

  @override
  Future<Either<Failure, List<Drug>>> searchDrugs(String query) async {
    return result!;
  }
}

void main() {
  late FakeDrugRepository fakeRepository;
  late SearchDrugsUseCase useCase;
  late SearchProvider provider;

  const testDrug = Drug(
    id: '1',
    name: 'Aspirin 100mg',
    price: '25',
    image: 'https://img.png',
  );

  setUp(() {
    fakeRepository = FakeDrugRepository();
    useCase = SearchDrugsUseCase(fakeRepository);
    provider = SearchProvider(searchDrugsUseCase: useCase);
  });

  test('initial state is correct', () {
    expect(provider.status, SearchStatus.initial);
    expect(provider.isInitial, isTrue);
    expect(provider.drugs, isEmpty);
  });

  test('empty query resets to initial state without calling usecase', () async {
    fakeRepository.result = const Right([testDrug]);

    await provider.search('   ');

    expect(provider.status, SearchStatus.initial);
    expect(provider.drugs, isEmpty);
  });

  test('search sets loaded state with drugs list on success', () async {
    fakeRepository.result = const Right([testDrug]);

    await provider.search('Aspirin');

    expect(provider.status, SearchStatus.loaded);
    expect(provider.isLoaded, isTrue);
    expect(provider.drugs.length, 1);
    expect(provider.drugs.first.name, 'Aspirin 100mg');
  });

  test('search sets error state on failure', () async {
    fakeRepository.result = const Left(ServerFailure('Network unreachable'));

    await provider.search('Aspirin');

    expect(provider.status, SearchStatus.error);
    expect(provider.isError, isTrue);
    expect(provider.errorMessage, 'Network unreachable');
    expect(provider.drugs, isEmpty);
  });

  test('clearSearch resets state to initial', () async {
    fakeRepository.result = const Right([testDrug]);
    await provider.search('Aspirin');
    expect(provider.isLoaded, isTrue);

    provider.clearSearch();

    expect(provider.status, SearchStatus.initial);
    expect(provider.drugs, isEmpty);
  });
}
