import 'package:new_project/parking%20report/ParkingModel.dart';


abstract class ParkingDataSource {
  Future<ParkingModel> getParkingReport();
}
