import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_repository.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/cubits/profile_cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileRepository _profileRepository;

  ProfileCubit({required this._profileRepository}) :super(ProfileInit());


  void getLProfile() async {
    emit(ProfileLoading());
    final localData = await _profileRepository.getProfile();
    localData.fold((error) {
      emit(ProfileError(message: error));
    },
            (data) {
          emit(ProfileSuccess(user: data));
        });
  }
}