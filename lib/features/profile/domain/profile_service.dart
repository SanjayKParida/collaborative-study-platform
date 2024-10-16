import 'dart:io';
import 'package:study_mesh/features/profile/data/profile_model.dart';
import 'package:study_mesh/features/profile/data/profile_repository.dart';

class ProfileService {
  final ProfileRepository _repository = ProfileRepository();

  Future<ProfileModel?> getCurrentUserProfile() async {
    return await _repository.getCurrentUserProfile();
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await _repository.updateProfile(profile);
  }

  Future<String> uploadProfileImage(File imageFile) async {
    return await _repository.uploadProfileImage(imageFile);
  }

  Future<void> signOut() async {
    await _repository.signOut();
  }
}
