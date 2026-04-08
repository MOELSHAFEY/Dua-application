import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dua/features/drug_details/domain/usecases/get_drug_info_usecase.dart';
import 'package:dua/features/drug_details/presentation/cubit/drug_details_state.dart';
class DrugDetailsCubit extends Cubit<DrugDetailsState> {
  final GetDrugInfoUseCase getDrugInfoUseCase;

  DrugDetailsCubit({required this.getDrugInfoUseCase}) : super(DrugDetailsInitial());

  Future<void> loadDrugInfo(String id) async {
    emit(DrugDetailsLoading());

    final result = await getDrugInfoUseCase(id);

    if (isClosed) return;

    result.fold(
      (failure) => emit(DrugDetailsError(failure.message)),
      (info) => emit(DrugDetailsLoaded(info)),
    );
  }
}
