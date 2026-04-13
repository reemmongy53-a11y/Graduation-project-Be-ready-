import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/app-const/app_const.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'vehicle_model.dart';
import 'vehicle_state.dart';

@injectable
class VehicleCubit extends Cubit<VehicleState> {
  final Dio _dio;
  VehicleCubit(this._dio) : super(VehicleInitialState());

  Future<void> registerVehicle({
    required String plateNumber,
  }) async {
    emit(VehicleLoadingState());

    try {
      // ✅ debug prints
      print('🚗 plateNumber: $plateNumber');
      print('🔑 token: ${UserSession.token}');
      print('🌐 endpoint: ${AppConst.vehicleRegisterEndPoint}');

      final response = await _dio.post(
        AppConst.vehicleRegisterEndPoint,
        data: {
          'plateNumber': plateNumber,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${UserSession.token}',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('✅ Response: ${response.data}');

      if (response.data['success'] == true) {
        emit(VehicleSuccessState(
          model: VehicleModel.fromJson(response.data['data']),
        ));
      } else {
        emit(VehicleErrorState(
          message: response.data['message'] ?? 'Error',
        ));
      }
    } on DioException catch (e) {
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      emit(VehicleErrorState(
        message: e.response?.data['message'] ?? 'Something went wrong',
      ));
    } catch (e) {
      print('❌ Unknown error: $e');
      emit(VehicleErrorState(message: e.toString()));
    }
  }
}