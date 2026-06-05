import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/app-const/app_const.dart';
import 'verify_otp_state.dart';

@injectable
class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final Dio _dio;
  VerifyOtpCubit(this._dio) : super(VerifyOtpInitial());

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    emit(VerifyOtpLoading());
    try {
      final response = await _dio.post(
        AppConst.verifyOtpEndPoint,
        data: {'email': email, 'otp': otp},
      );
      emit(VerifyOtpSuccess(token: response.data['token'] ?? ''));
    } on DioException catch (e) {
      emit(VerifyOtpError(
        message: e.response?.data['message'] ?? 'Invalid OTP',
      ));
    } catch (e) {
      emit(VerifyOtpError(message: e.toString()));
    }
  }

  Future<void> resendOtp({required String email}) async {
    emit(VerifyOtpLoading());
    try {
      await _dio.post(
        AppConst.forgotPasswordEndPoint,
        data: {'email': email},
      );
      emit(VerifyOtpResendSuccess()); // ✅ بدل VerifyOtpInitial
    } on DioException catch (e) {
      emit(VerifyOtpError(
        message: e.response?.data['message'] ?? 'Failed to resend OTP',
      ));
    } catch (e) {
      emit(VerifyOtpError(message: e.toString()));
    }
  }
}