

import 'package:get_it/get_it.dart';
import 'package:planet_sushi_client_app/features/auth/data/datasource/auth_data_source.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/providers/login_state.dart';

final sl=GetIt.instance;

Future<void> init() async{
  sl.registerLazySingleton<LoginState>(()
  => LoginState());
  sl.registerLazySingleton(() => AuthDataSource());

  //cubits
  sl.registerFactory(() => AuthCubit());

}