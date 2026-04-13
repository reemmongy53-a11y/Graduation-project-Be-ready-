import 'package:dartz/dartz.dart';
import 'package:new_project/core/errors/failure.dart';
import 'profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> getProfile();
  Future<Either<Failure, ProfileModel>> updateProfile({
    required String name,
    required String email,
    String? password,
    String? plateNumber, // ✅ أضفنا
  });
}