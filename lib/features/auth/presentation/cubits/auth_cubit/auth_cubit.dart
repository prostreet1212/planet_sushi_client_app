import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/data/datasource/auth_data_source.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthDataSource _authDataSource;
  AuthCubit({required this._authDataSource}) : super(AuthInitial());

  void sendCode(String number) async {
    final authData = await _authDataSource.sendCode(number);
    authData.fold(
      (error) {
        emit(AuthError(message: error));
      },
      (success) {
        emit(AuthSuccess());
      },
    );
  }
}
