import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/data/models/user_model.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_remote_data_source.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_sync_service.dart';
import '../../../data/datasource/auth_data_source.dart';
import 'add_user_state.dart';

class AddUserCubit extends Cubit<AddUserState>{
  //final ProfileRemoteDataSource _profileRemoteDataSource;
  final ProfileSyncService _profileSyncService;
  AddUserCubit({required this._profileSyncService}) : super(AddUserInitial());

  void addUser(UserModel user) async{
    final addUserData = await _profileSyncService.insertProfile(user);
    addUserData.fold(
            (error) {
              emit(AddUserError(message: error));
            },
            (success){
              emit(AddUserSuccess());
    });
  }
}