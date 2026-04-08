import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dua/features/drug_search/domain/usecases/search_drugs_usecase.dart';
import 'package:dua/features/drug_search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchDrugsUseCase searchDrugsUseCase;

  SearchCubit({required this.searchDrugsUseCase}) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await searchDrugsUseCase(query);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (drugs) => emit(SearchLoaded(drugs)),
    );
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}
