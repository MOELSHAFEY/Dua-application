import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_drug_info_usecase.dart';

enum DrugDetailsStatus {
  initial,
  loading,
  loaded,
  error,
}

class DrugDetailsProvider extends ChangeNotifier {
  final GetDrugInfoUseCase getDrugInfoUseCase;

  DrugDetailsStatus _status = DrugDetailsStatus.initial;
  String _drugInfo = '';
  String _errorMessage = '';
  bool _isDisposed = false;

  DrugDetailsProvider({required this.getDrugInfoUseCase});

  DrugDetailsStatus get status => _status;
  bool get isLoading => _status == DrugDetailsStatus.loading;
  bool get isLoaded => _status == DrugDetailsStatus.loaded;
  bool get isError => _status == DrugDetailsStatus.error;
  String get drugInfo => _drugInfo;
  String get errorMessage => _errorMessage;

  Future<void> loadDrugInfo(String id) async {
    _status = DrugDetailsStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await getDrugInfoUseCase(id);

    if (_isDisposed) return;

    result.fold(
      (failure) {
        _status = DrugDetailsStatus.error;
        _errorMessage = failure.message;
      },
      (info) {
        _status = DrugDetailsStatus.loaded;
        _drugInfo = info;
      },
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
