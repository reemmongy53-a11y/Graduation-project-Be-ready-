import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/errors/failure.dart';
import 'profile_data_source.dart';
import 'profile_model.dart';
import 'profile_repository.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource;
  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      final result = await _dataSource.getProfile();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Something went wrong'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile({
    required String name,
    required String email,
    String? password,
    String? plateNumber, // ✅ أضفنا
  }) async {
    try {
      final result = await _dataSource.updateProfile(
        name: name,
        email: email,
        password: password,
        plateNumber: plateNumber, // ✅ أضفنا
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Something went wrong'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}