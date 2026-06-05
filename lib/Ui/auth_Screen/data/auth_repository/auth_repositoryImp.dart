import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/Ui/auth_Screen/data/auth_data_sourse/auth_data_source.dart';
import 'package:new_project/Ui/auth_Screen/data/auth_data_sourse/auth_data_source_impe.dart';
import 'package:new_project/Ui/auth_Screen/data/model/SignUp_Model.dart';
import 'package:new_project/Ui/auth_Screen/domain/auth_repository/auth-repository.dart';
import 'package:new_project/Ui/auth_Screen/domain/enites/auth_result.dart';
import 'package:new_project/core/errors/failure.dart';
@Injectable(as: AuthRepository)
class AuthRepositoryImp implements AuthRepository {
  AuthDataSource _authDataSource;
  AuthRepositoryImp(this._authDataSource);
  @override
  Future<Either<Failure, AuthResult>> signUp({required String name,required String email,required String password,required String role,})async {
    try {
   final result = await   _authDataSource.signUp(name: name,
          email: email,
          password: password,
          role: role,

          )
          .then((value) => value);
   return Right(result.toEntity());
    }on DioException catch (e) {
      print('=== DioError ===');
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print('Message: ${e.message}');

      // ← الحل هنا
      String errorMessage;
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        errorMessage = 'تعذر الاتصال بالسيرفر، تحقق من الإنترنت';
      } else {
        errorMessage = e.response?.data?["message"] ?? 'حدث خطأ';
      }

      return Left(ServerFailure(message: errorMessage));
    }}
}