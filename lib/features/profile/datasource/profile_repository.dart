import 'package:dartz/dartz.dart';
import 'package:planet_sushi_client_app/core/error/exception.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_local_data_source.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../auth/data/models/user_model.dart';


//рабочий образец с обработкой ошибок
class ProfileRepository {
  final ProfileRemoteDataSource _profileRemoteDataSource;
  final ProfileLocalDataSource _profileLocalDataSource;
  final Supabase _supabase;

  ProfileRepository({
    required this._profileRemoteDataSource,
    required this._profileLocalDataSource,
    required this._supabase,
  });


  Future<Either<String, UserModel>> getProfile() async {
    UserModel? userModel=await _profileLocalDataSource.getProfile();
    return Right(userModel!);

  }

  Future<Either<String, Null>> insertProfile(UserModel user) async {
    try {
      if(user.id==null){
        String? userId = _supabase.client.auth.currentUser?.id;
        user=user.copyWith(id: userId);
      }
      final remote = await _profileRemoteDataSource.createProfile(user);
      try {
        final local = await _profileLocalDataSource.insertProfile(user);
      } on CacheException catch (e) {
        //если не записалось в локальную бд, не критично
      }
      return const Right(null);
    }on ServerException catch (e) {
      return Left(e.error);
    }
  }

  Future<Either<String,Null>> insertLocalProfile(UserModel user)async{
    try {
      final local = await _profileLocalDataSource.insertProfile(user);
    } on CacheException catch (e) {
      //если не записалось в локальную бд, не критично
    }
    return const Right(null);
  }
}
