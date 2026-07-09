

import 'package:get_it/get_it.dart';
import 'package:planet_sushi_client_app/features/auth/data/datasource/auth_data_source.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubits/add_user_cubit/add_user_cubit.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubits/otp_cubit/otp_cubit.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/providers/login_state.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/name_screen/providers/name_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/cubits/auth_cibit/auth_cubit.dart';

final sl=GetIt.instance;

Future<void> init() async{


  /*sl.registerLazySingleton<LoginState>(()
  => LoginState());*/
  sl.registerLazySingleton(() => AuthDataSource(supabase: sl()));

  //states
  sl.registerFactory(() => AuthCubit(authDataSource: sl()));
  sl.registerFactory(() => OtpCubit(authDataSource: sl()));
  sl.registerFactory(() => AddUserCubit(authDataSource: sl()));
  sl.registerFactory(() => LoginState());
  sl.registerLazySingleton(() => NameState());

  //external
  final supabase =  Supabase.instance;
  sl.registerLazySingleton(() => supabase);



}