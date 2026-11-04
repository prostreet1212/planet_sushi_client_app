import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/data/models/user_model.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_repository.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/cubits/profile_cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileRepository _profileRepository;

  ProfileCubit({required this._profileRepository}) : super(ProfileLoading());

  void getLProfile() async {
    emit(ProfileLoading());
    final localData = await _profileRepository.getProfile();
    localData.fold(
      (error) {
        emit(ProfileError(message: error));
      },
      (data) {
        if (data.name == null || data.name == '') {
          emit(ProfileIncomplete(user: data));
        } else {
          emit(ProfileSuccess(user: data));
        }
      },
    );
  }

  void deleteProfile(UserModel user) async {
    final localData = await _profileRepository.deleteLocalProfile(user);
    localData.fold(
        (error){
          emit(ProfileError(message: error));
        },
        (data){
          emit(ProfileEmpty());
        }
    );
  }
}
