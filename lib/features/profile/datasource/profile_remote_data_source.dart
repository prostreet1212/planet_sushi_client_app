
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:planet_sushi_client_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/exception.dart';

class ProfileRemoteDataSource {
  final Supabase supabase;

  ProfileRemoteDataSource({required this.supabase});

  String get _userId => supabase.client.auth.currentUser?.id ?? '';
  
  Future<UserModel?> getProfile()async{
    try{
      if (_userId.isEmpty) {
        return null;
      }
      final response=await supabase.client.from('users').select().eq('id', _userId).maybeSingle();
      if(response==null||response.isEmpty){return null;}
      UserModel user=UserModel.fromJson(response);
      return user;

    }catch(e){
      String error='Ошибка загрузки профиля: $e';
      print(error);
      throw ServerException(error: error.toString());
    }

    
  }

  Future<void> createProfile(UserModel user) async {
    try {
     // String? userId = supabase.client.auth.currentUser?.id;
        Map<String, dynamic> data = /*(user.copyWith(id: userId))*/user.toJson();
          await supabase.client.from('users').insert(data);

    } catch (e) {
      String error = e.toString();
      debugPrint(error);
    }
  }


}