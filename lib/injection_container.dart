

import 'package:get_it/get_it.dart';
import 'package:planet_sushi_client_app/core/routers/app_router.dart';
import 'package:planet_sushi_client_app/features/auth/data/datasource/auth_data_source.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubits/add_user_cubit/add_user_cubit.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubits/otp_cubit/otp_cubit.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/providers/login_state.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/name_screen/providers/name_state.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/otp_screen/providers/otp_phone_state.dart';
import 'package:planet_sushi_client_app/features/cart/datasource/cart_local_data_source.dart';
import 'package:planet_sushi_client_app/features/cart/datasource/cart_remote_data_source.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/providers/main_screen_state.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/cubits/auth_cibit/auth_cubit.dart';
import 'features/database/database.dart';
import 'features/shop/datasource/shop_local_data_source.dart';
import 'features/shop/datasource/shop_sync_service.dart';
import 'features/shop/datasource/shop_remote_data_source.dart';
import 'features/shop/presentation/cubits/catalog_cubit/catalog_cubit.dart';

final sl=GetIt.instance;

Future<void> init() async{


  /*sl.registerLazySingleton<LoginState>(()
  => LoginState());*/
  sl.registerLazySingleton(() => AuthDataSource(supabase: sl()));
  sl.registerLazySingleton(() => ShopRemoteDataSource(supabase: sl()));


 //cubits
  sl.registerFactory(() => AuthCubit(authDataSource: sl()));
  sl.registerFactory(() => OtpCubit(authDataSource: sl()));
  sl.registerFactory(() => AddUserCubit(authDataSource: sl()));
  //sl.registerFactory(() => CatalogCubit(shopDataSource: sl()));
  sl.registerFactory(() => CatalogCubit(syncService: sl()));
  sl.registerFactory(() => CartCubit(cartLocalDataSource: sl()));

  //states
  sl.registerFactory(() => LoginState());
  sl.registerLazySingleton(() => NameState());
  sl.registerLazySingleton(() => OtpPhoneState());
  //sl.registerLazySingleton(() => MainScreenState());

  //external
  final supabase =  Supabase.instance;
  sl.registerLazySingleton<Supabase>(() => supabase);
  sl.registerLazySingleton(()=>AppRouter(

  ));

  // database
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<ShopLocalDataSource>(() => ShopLocalDataSource( db: sl()));
  sl.registerLazySingleton<ShopSyncService>(() => ShopSyncService(
    remoteDataSource: sl(),
    localDao: sl(),
  ));
  sl.registerLazySingleton(() => CartLocalDataSource(db: sl()));
  sl.registerLazySingleton(() => CartRemoteDataSource(supabase: sl()));

  sl.registerLazySingleton(()=>ProfileRemoteDataSource(supabase: sl()));





}