import 'attendance_model.dart';

abstract class AttendanceState {}

class AttendanceInitialState extends AttendanceState {}
class AttendanceLoadingState extends AttendanceState {}

class AttendanceSuccessState extends AttendanceState {
  final AttendanceModel model;
  AttendanceSuccessState({required this.model});

}

class AttendanceErrorState extends AttendanceState {
  final String message;
  AttendanceErrorState({required this.message});
}