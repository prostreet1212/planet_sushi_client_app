import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_local_data_source.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_repository.dart';
import '../../../data/datasource/auth_data_source.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthDataSource _authDataSource;
  final ProfileRepository _profileRepository;
  OtpCubit({required this._authDataSource, required this._profileRepository}) : super(OtpInitial());

  void verifyOtp(String number,String token) async {
    final authData =await _authDataSource.verifyOtp(number, token);
    authData.fold(
          (error) {
        emit(OtpError(message: error));
      },
          (success) async {
            //если пользователя есть в supabase таблице
            if(success!=null){
              //запишем юзера в локальную бд
               final profileData=await _profileRepository.insertLocalProfile(success);
               profileData.fold((error){}, (profile){
               });
              emit(OtpSuccess(user: success));

            }else{
              emit(OtpNext());
            }
      },
    );
  }
}