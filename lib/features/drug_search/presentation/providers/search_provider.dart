import 'package:flutter/foundation.dart';
import '../../../../core/entities/drug.dart';
import '../../domain/usecases/search_drugs_usecase.dart';

enum SearchStatus {
  initial,
  loading,
  loaded,
  error,
}

class SearchProvider extends ChangeNotifier {
  final SearchDrugsUseCase searchDrugsUseCase;

  SearchStatus _status = SearchStatus.initial;
  List<Drug> _drugs = [];
  String _errorMessage = '';

  SearchProvider({required this.searchDrugsUseCase});

  SearchStatus get status => _status;
  bool get isInitial => _status == SearchStatus.initial;
  bool get isLoading => _status == SearchStatus.loading;
  bool get isLoaded => _status == SearchStatus.loaded;
  bool get isError => _status == SearchStatus.error;
  List<Drug> get drugs => List.unmodifiable(_drugs);
  String get errorMessage => _errorMessage;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _status = SearchStatus.initial;
      _drugs = [];
      _errorMessage = '';
      notifyListeners();
      return;
    }

    _status = SearchStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await searchDrugsUseCase(query);

    result.fold(
      (failure) {
        _status = SearchStatus.error;
        _errorMessage = failure.message;
        _drugs = [];
      },
      (drugsList) {
        _status = SearchStatus.loaded;
        _drugs = drugsList;
      },
    );
    notifyListeners();
  }

  void clearSearch() {
    _status = SearchStatus.initial;
    _drugs = [];
    _errorMessage = '';
    notifyListeners();
  }
}
