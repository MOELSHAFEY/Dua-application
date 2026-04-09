import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_version_usecase.dart';
import 'access_state.dart';

class AccessCubit extends Cubit<AccessState> {
  final CheckVersionUseCase checkVersionUseCase;
  static const String currentVersion = "5.0.0";

  AccessCubit({required this.checkVersionUseCase}) : super(AccessInitial());

  Future<void> checkAccess() async {
    emit(AccessLoading());

    final result = await checkVersionUseCase(NoParams());

    result.fold(
      (failure) => emit(AccessError(failure.message)),
      (appVersion) {
        if (appVersion.version == currentVersion) {
          emit(AccessAuthorized());
        } else {
          emit(AccessUpdateRequired(appVersion.url));
        }
      },
    );
  }
}
