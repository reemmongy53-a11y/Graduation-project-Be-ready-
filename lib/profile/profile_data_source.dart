import 'package:new_project/profile/profile_model.dart';

abstract class ProfileDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
    String? password,
    String? plateNumber, // ✅ أضفنا
  });
}