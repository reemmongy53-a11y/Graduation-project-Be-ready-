abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}
class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final String token;
  VerifyOtpSuccess({required this.token});
}

class VerifyOtpResendSuccess extends VerifyOtpState {} // ✅ جديد

class VerifyOtpError extends VerifyOtpState {
  final String message;
  VerifyOtpError({required this.message});
}
