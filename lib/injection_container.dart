

import 'package:get_it/get_it.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/providers/login_state.dart';

final sl=GetIt.instance;

Future<void> init() async{
  sl.registerLazySingleton<LoginState>(()
  => LoginState());

}