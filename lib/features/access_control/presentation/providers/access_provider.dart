import 'package:flutter/foundation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_version_usecase.dart';

enum AccessStatus {
  initial,
  loading,
  authorized,
  updateRequired,
  error,
}

class AccessProvider extends ChangeNotifier {
  final CheckVersionUseCase checkVersionUseCase;
  static const String currentVersion = "5.0.0";

  AccessStatus _status = AccessStatus.initial;
  String _updateUrl = '';
  String _errorMessage = '';

  AccessProvider({required this.checkVersionUseCase});

  AccessStatus get status => _status;
  bool get isLoading => _status == AccessStatus.loading;
  bool get isAuthorized => _status == AccessStatus.authorized;
  bool get isUpdateRequired => _status == AccessStatus.updateRequired;
  bool get isError => _status == AccessStatus.error;
  String get updateUrl => _updateUrl;
  String get errorMessage => _errorMessage;

  Future<void> checkAccess() async {
    _status = AccessStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await checkVersionUseCase(NoParams());

    result.fold(
      (failure) {
        _status = AccessStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (appVersion) {
        if (appVersion.version == currentVersion) {
          _status = AccessStatus.authorized;
        } else {
          _status = AccessStatus.updateRequired;
          _updateUrl = appVersion.url;
        }
        notifyListeners();
      },
    );
  }
}
