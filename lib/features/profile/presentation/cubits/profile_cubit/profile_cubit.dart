

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_sync_service.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/cubits/profile_cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState>{
  ProfileSyncService _profileSyncService;
  ProfileCubit({required this._profileSyncService}):super(ProfileInit());

  void getLProfile(){
   ///
  }
}