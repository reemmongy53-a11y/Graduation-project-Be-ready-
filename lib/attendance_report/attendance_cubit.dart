import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'attendance_repository.dart';
import 'attendance_state.dart';

@injectable
class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRepository _repository;
  AttendanceCubit(this._repository) : super(AttendanceInitialState());

  Future<void> getReport() async {
    emit(AttendanceLoadingState());
    final result = await _repository.getReport();
    result.fold(
          (failure) => emit(AttendanceErrorState(message: failure.message)),
          (model) {
        // ✅ Print هنا عشان نشوف البيانات الجاية من الـ API
        print("✅ Present: ${model.summary.presentDays}");
        print("❌ Absent: ${model.summary.absentDays}");
        print("⏰ Late: ${model.summary.lateDays}");

        emit(AttendanceSuccessState(model: model));
      },
    );
  }
}