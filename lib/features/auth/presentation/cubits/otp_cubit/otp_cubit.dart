import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/auth_data_source.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthDataSource _authDataSource;
  OtpCubit({required this._authDataSource}) : super(OtpInitial());

  void verifyOtp(String number,String token) async {
    final authData =await _authDataSource.verifyOtp(number, token);
    authData.fold(
          (error) {
        emit(OtpError(message: error));
      },
          (success) {
        emit(OtpSuccess());
      },
    );
  }
}