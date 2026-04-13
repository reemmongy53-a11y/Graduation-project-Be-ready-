

import 'package:new_project/parking%20report/ParkingModel.dart';

abstract class ParkingState {}

class ParkingInitialState extends ParkingState {}
class ParkingLoadingState extends ParkingState {}

class ParkingSuccessState extends ParkingState {
  final ParkingModel model;
  ParkingSuccessState({required this.model});
}

class ParkingErrorState extends ParkingState {
  final String message;
  ParkingErrorState({required this.message});
}