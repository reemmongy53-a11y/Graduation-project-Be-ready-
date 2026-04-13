import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/app-const/app_const.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/parking%20report/ParkingDataSource.dart';
import 'package:new_project/parking%20report/ParkingModel.dart';

@Injectable(as: ParkingDataSource)
class ParkingDataSourceImpl implements ParkingDataSource {
  final Dio dio;
  ParkingDataSourceImpl(this.dio);

  Options get _options => Options(
    headers: {'Authorization': 'Bearer ${UserSession.token}'},
  );

  @override
  Future<ParkingModel> getParkingReport() async {
    final response = await dio.get(
      AppConst.parkingReportEndPoint,
      options: _options,
    );
    if (response.statusCode == 200) {
      return ParkingModel.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch parking report');
    }
  }
}