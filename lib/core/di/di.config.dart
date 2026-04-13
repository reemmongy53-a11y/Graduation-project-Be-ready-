// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../attendance_report/attendance_cubit.dart' as _i741;
import '../../attendance_report/attendance_data_source.dart' as _i64;
import '../../attendance_report/attendance_data_source_impl.dart' as _i267;
import '../../attendance_report/attendance_repository.dart' as _i47;
import '../../attendance_report/attendance_repository_impl.dart' as _i515;
import '../../check_in/check_in_cubit.dart' as _i453;
import '../../data_logIn/login_cubit.dart' as _i920;
import '../../data_logIn/login_data_source.dart' as _i340;
import '../../data_logIn/login_data_source_impl.dart' as _i410;
import '../../data_logIn/login_repository.dart' as _i635;
import '../../data_logIn/login_repository_impl.dart' as _i365;
import '../../data_qr/qr_cubit.dart' as _i566;
import '../../data_qr/qr_data_source.dart' as _i527;
import '../../data_qr/qr_data_source_impl.dart' as _i882;
import '../../data_qr/qr_repository.dart' as _i986;
import '../../data_qr/qr_repository_impl.dart' as _i750;
import '../../Dio/dio_module.dart' as _i804;
import '../../forgetPassword/forgot_password_cubit.dart' as _i1036;
import '../../forgetPassword/reset_password_cubit.dart' as _i387;
import '../../forgetPassword/verify_otp_cubit.dart' as _i51;
import '../../logOut/logout_cubit.dart' as _i913;
import '../../parking%20report/ParkingCubit.dart' as _i149;
import '../../parking%20report/ParkingDataSource.dart' as _i5;
import '../../parking%20report/ParkingDataSourceImpl.dart' as _i709;
import '../../parking%20report/ParkingRepository.dart' as _i869;
import '../../parking%20report/ParkingRepositoryImpl.dart' as _i539;
import '../../profile/profile_cubit.dart' as _i985;
import '../../profile/profile_data_source.dart' as _i568;
import '../../profile/profile_data_source_impl.dart' as _i758;
import '../../profile/profile_repository.dart' as _i305;
import '../../profile/profile_repository_impl.dart' as _i961;
import '../../Ui/auth_cubit/signUp_cubit.dart' as _i435;
import '../../Ui/auth_Screen/data/auth_data_sourse/auth_data_source.dart'
    as _i494;
import '../../Ui/auth_Screen/data/auth_data_sourse/auth_data_source_impe.dart'
    as _i739;
import '../../Ui/auth_Screen/data/auth_repository/auth_repositoryImp.dart'
    as _i779;
import '../../Ui/auth_Screen/domain/auth_repository/auth-repository.dart'
    as _i707;
import '../../vehicle/vehicle_cubit.dart' as _i1019;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.singleton<_i361.Dio>(() => dioModule.dio);
    gh.factory<_i64.AttendanceDataSource>(
      () => _i267.AttendanceDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i340.LoginDataSource>(
      () => _i410.LoginDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i635.LoginRepository>(
      () => _i365.LoginRepositoryImpl(gh<_i340.LoginDataSource>()),
    );
    gh.factory<_i920.LoginCubit>(
      () => _i920.LoginCubit(gh<_i635.LoginRepository>()),
    );
    gh.factory<_i5.ParkingDataSource>(
      () => _i709.ParkingDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i527.QrDataSource>(
      () => _i882.QrDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i47.AttendanceRepository>(
      () => _i515.AttendanceRepositoryImpl(gh<_i64.AttendanceDataSource>()),
    );
    gh.factory<_i568.ProfileDataSource>(
      () => _i758.ProfileDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i494.AuthDataSource>(
      () => _i739.AuthDataSourceImpe(gh<_i361.Dio>()),
    );
    gh.factory<_i453.CheckInCubit>(() => _i453.CheckInCubit(gh<_i361.Dio>()));
    gh.factory<_i1036.ForgotPasswordCubit>(
      () => _i1036.ForgotPasswordCubit(gh<_i361.Dio>()),
    );
    gh.factory<_i387.ResetPasswordCubit>(
      () => _i387.ResetPasswordCubit(gh<_i361.Dio>()),
    );
    gh.factory<_i51.VerifyOtpCubit>(() => _i51.VerifyOtpCubit(gh<_i361.Dio>()));
    gh.factory<_i913.LogoutCubit>(() => _i913.LogoutCubit(gh<_i361.Dio>()));
    gh.factory<_i1019.VehicleCubit>(() => _i1019.VehicleCubit(gh<_i361.Dio>()));
    gh.factory<_i986.QrRepository>(
      () => _i750.QrRepositoryImpl(gh<_i527.QrDataSource>()),
    );
    gh.factory<_i305.ProfileRepository>(
      () => _i961.ProfileRepositoryImpl(gh<_i568.ProfileDataSource>()),
    );
    gh.factory<_i707.AuthRepository>(
      () => _i779.AuthRepositoryImp(gh<_i494.AuthDataSource>()),
    );
    gh.factory<_i435.SignupCubit>(
      () => _i435.SignupCubit(gh<_i707.AuthRepository>()),
    );
    gh.factory<_i566.QrCubit>(() => _i566.QrCubit(gh<_i986.QrRepository>()));
    gh.factory<_i741.AttendanceCubit>(
      () => _i741.AttendanceCubit(gh<_i47.AttendanceRepository>()),
    );
    gh.factory<_i869.ParkingRepository>(
      () => _i539.ParkingRepositoryImpl(gh<_i5.ParkingDataSource>()),
    );
    gh.factory<_i985.ProfileCubit>(
      () => _i985.ProfileCubit(gh<_i305.ProfileRepository>()),
    );
    gh.factory<_i149.ParkingCubit>(
      () => _i149.ParkingCubit(gh<_i869.ParkingRepository>()),
    );
    return this;
  }
}

class _$DioModule extends _i804.DioModule {}
