import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/parking%20report/ParkingRepository.dart';
import 'package:new_project/parking%20report/ParkingState.dart';

@injectable
class ParkingCubit extends Cubit<ParkingState> {
  final ParkingRepository _repository;
  ParkingCubit(this._repository) : super(ParkingInitialState());

  Future<void> getParkingReport() async {
    emit(ParkingLoadingState());
    final result = await _repository.getParkingReport();

    result.fold(
          (failure) => emit(ParkingErrorState(message: failure.message)),
          (model) {
        // ✅ Print عشان نشوف البيانات
        print("🚗 PARKING DETAILS: ${model.details}");
        emit(ParkingSuccessState(model: model));
      },
    );
  }
}