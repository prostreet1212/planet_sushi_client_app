import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exception.dart';
import '../../../profile/datasource/profile_local_data_source.dart';
import '../models/user_model.dart';

enum AuthStepStatus { success, next }

/// Итоговый статус авторизации пользователя
enum AppAuthStatus {
  /// Есть сессия и запись в таблице users — полностью авторизован
  fullyAuthorized,

  /// Сессия есть, но записи в users нет — не завершил регистрацию имени
  incomplete,

  /// Сессии нет — не авторизован
  unauthorized,
}

class AuthDataSource {
  final Supabase _supabase;
  ProfileRepository _profileRepository;
  ProfileLocalDataSource _profileLocalDataSource;

  AuthDataSource({
    required this._supabase,
    required this._profileRepository,
    required this._profileLocalDataSource,
  });

  Future<Either<String,bool>>checkPrevLogin() async {
    try{
      if (_supabase.client.auth.currentUser?.id != null) {
        UserModel? localUser = await _profileLocalDataSource.getProfile();
        if (localUser!=null) {
          String authUser = _supabase.client.auth.currentUser!.id;
          if (authUser == localUser.id) {
            return Right(true);
          }else{
            return Right(false);
          }
        }else{
          return Right(false);
        }


      }else{
        return Right(false);
      }
    }catch (e) {
      String error = e.toString();
      return Left(error);
    }
  }

  Future<Either<String, Null>> sendCode(String number) async {
    String phoneNumber = '+7$number';
    debugPrint(phoneNumber);
    try {
      await _supabase.client.auth.signInWithOtp(phone: phoneNumber);
      return const Right(null);
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(phone: phoneNumber,)));
    } catch (e) {
      String error = e.toString();
      debugPrint(error);
      return Left(error);
    }
  }

  Future<Either<String, UserModel?>> verifyOtp(
    String number,
    String token,
  ) async {
    try {
      // Подтверждаем код
      final response = await _supabase.client.auth.verifyOTP(
        phone: number,
        token: token,
        type: OtpType.sms,
      );
      if (response.session != null) {
        print(response.session!.user);
        String message = 'auth completed';
        print(message);
        final Map<String, dynamic>? data = await _supabase.client
            .from('users')
            .select()
            .eq('id', response.session!.user.id)
            .maybeSingle();
        if (data == null) {
          return const Right(null);
        } else {
          final UserModel user = UserModel.fromJson(data);
          return Right(user);
        }
      }
      return const Left('');
    } on AuthApiException catch (e) {
      String error = e.toString();
      print('otp error: $error');
      //if(e.statusCode=='403'){
      return Left(error);
      /* otpIsValid=false;
      pinController.triggerError();
      _formKey.currentState?.validate();*/
      //}
    } catch (e) {
      String error = e.toString();
      print('otp error: $error');
      return Left(error);
    }
  }

  Future<Either<String,Null>> logOut() async {
   try{
     if (_supabase.client.auth.currentUser != null) {
       await _supabase.client.auth.signOut();
       return Right(null);
     }else{
       return Left('пользователь уже вышел');
     }
   }catch(e){
     return Left(e.toString());
   }
  }

  Stream<AuthState> authStatusStream() =>
      _supabase.client.auth.onAuthStateChange;

  /*StreamSubscription authStatusStreamSubscription() =>
  authStatusStream().listen((event){

  });*/

  /// Полная проверка: сессия + запись в таблице users
  Future<AppAuthStatus> checkStatus() async {
    final user = _supabase.client.auth.currentUser;
    if (user == null) return AppAuthStatus.unauthorized;

    final profileData = await _profileRepository.getProfile();
    return profileData.fold(
      (error) {
        return AppAuthStatus.incomplete;
      },
      (profile) {
         if(profile.name == '' || profile.name == null){
       return AppAuthStatus.incomplete;
     }else{
        return AppAuthStatus.fullyAuthorized;
         }
      },
    );




    //return AppAuthStatus.fullyAuthorized;

    /* try {
      final data = await _supabase.client
          .from('users')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();
      return data != null
          ? AppAuthStatus.fullyAuthorized
          : AppAuthStatus.incomplete;
    } catch (_) {
      // Ошибка сети/бд не должна считать пользователя неавторизованным,
      // сессия сама по себе валидна
      return AppAuthStatus.fullyAuthorized;
    }*/
  }

  /* Future<void> checkUserStatus() async {
    final session = _supabase.client.auth.currentSession;
    if (session != null) {
      try {
        // Делаем легкий запрос к auth.getUser(), он всегда идет на сервер
        await _supabase.client.auth.getUser(session.accessToken);
      } catch (e) {
        // Если пользователя нет на сервере, getUser выбросит ошибку
        await _supabase.client.auth.signOut();
      }
    }
  }*/
}
