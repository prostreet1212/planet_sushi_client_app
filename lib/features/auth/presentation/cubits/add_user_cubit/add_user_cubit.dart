import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/data/models/user_model.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_remote_data_source.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/datasource/auth_data_source.dart';
import 'add_user_state.dart';

class AddUserCubit extends Cubit<AddUserState>{
  //final ProfileRepositoryurce _profileRemoteDataSource;
  final ProfileRepository _profileRepository;
  AddUserCubit({required this._profileRepository}) : super(AddUserInitial());

  void addUser(UserModel user) async{
    //закладка
    final addUserData = await _profileRepository.insertProfile(user);
    addUserData.fold(
            (error) {
              emit(AddUserError(message: error));
            },
            (success){
              emit(AddUserSuccess());
    });
  }


}