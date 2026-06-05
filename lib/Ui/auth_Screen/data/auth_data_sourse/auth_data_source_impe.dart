import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/Ui/auth_Screen/data/auth_data_sourse/auth_data_source.dart';
import 'package:new_project/Ui/auth_Screen/data/model/SignUp_Model.dart';
import 'package:new_project/core/app-const/app_const.dart';



@Injectable(as: AuthDataSource)
class AuthDataSourceImpe implements AuthDataSource {
  final Dio dio;
  AuthDataSourceImpe(this.dio);
  @override
  Future<SignUpModel> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    // ← ضيف دول مؤقتاً عشان نشوف بيروح على فين
    print('🔥 baseUrl: ${AppConst.baseUrl}');
    print('🔥 Full URL: ${AppConst.baseUrl}${AppConst.signUpEndPoint}');

    try {
      final response = await dio.post(
        AppConst.signUpEndPoint,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "role": role,
        },
      );

      print('✅ statusCode: ${response.statusCode}');
      print('✅ response: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return SignUpModel.fromJson(response.data);
      } else {
        throw Exception("Message");
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.type}');
      print('❌ message: ${e.message}');
      print('❌ response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }}