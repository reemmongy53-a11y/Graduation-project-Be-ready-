import 'package:new_project/Ui/complaint/app_config.dart';


abstract class AppConst {
  static String get baseUrl => AppConfig.baseUrl;

  static const String signUpEndPoint = 'auth/signup';
  static const String loginEndPoint = 'auth/login';
  static const String myQrEndPoint = 'qr/my-qr';
  static const String attendanceReportEndPoint = 'attendance/report';
  static const String qrCheckInEndPoint = 'attendance/qr';
  static const String employeeProfileEndPoint = 'employee/profile';
  static const String updateProfileEndPoint = 'employee/update-profile';
  static const String vehicleRegisterEndPoint = 'vehicle/register';
  static const String forgotPasswordEndPoint = 'auth/forgot-password';
  static const String resetPasswordEndPoint = 'auth/change-password';
  static const String logoutEndPoint = 'auth/logout';
  static const String verifyOtpEndPoint = 'auth/verify-otp';
  static const String parkingReportEndPoint = 'parking/report';
}