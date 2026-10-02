import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/data/datasource/auth_data_source.dart';
import 'send_code_state.dart';

class SendCodeCubit extends Cubit<SendCodeState> {
  final AuthDataSource _authDataSource;
  SendCodeCubit({required this._authDataSource}) : super(SendCodeInitial());

  void sendCode(String number) async {
    //сначала проверим пытался ли пользователь войти ранее
    final checkData=await _authDataSource.checkPrevLogin();
    checkData.fold(
          (error) async {
            final sendCodeData = await _authDataSource.sendCode(number);
            sendCodeData.fold(
                  (error) {
                emit(SendCodeError(message: error));
              },
                  (success) {
                emit(SendCodeSuccess());
              },
            );
      },
          (success) async {
            if(success){
              emit(SendCodeSkip());
            }else{
              final authData = await _authDataSource.sendCode(number);
              authData.fold(
                    (error) {
                  emit(SendCodeError(message: error));
                },
                    (success) {
                  emit(SendCodeSuccess());
                },
              );
            }
      },
    );

  }
}
