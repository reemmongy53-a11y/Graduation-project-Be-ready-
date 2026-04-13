import 'package:dartz/dartz.dart';
import 'package:new_project/core/errors/failure.dart';
import 'package:new_project/parking%20report/ParkingModel.dart';


abstract class ParkingRepository {
  Future<Either<Failure, ParkingModel>> getParkingReport();
}