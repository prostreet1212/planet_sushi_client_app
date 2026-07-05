import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/data/datasource/auth_data_source.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void sendCode(String number) async {
    final authData = await di.sl<AuthDataSource>().sendCode(number);
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
