import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exception.dart';
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

  AuthDataSource({required this._supabase, required this._profileRepository});

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

  Stream<AuthState> authStatusStream() =>
      _supabase.client.auth.onAuthStateChange;

  StreamSubscription authStatusStreamSubscription() =>
  authStatusStream().listen((event){

  });

  /// Полная проверка: сессия + запись в таблице users
  Future<AppAuthStatus> checkStatus() async {
    final user = _supabase.client.auth.currentUser;
    if (user == null) return AppAuthStatus.unauthorized;

    final profileData = await _profileRepository.getProfile();
    return profileData.fold((error) {
      return AppAuthStatus.incomplete;
    }, (profile) {
        return AppAuthStatus.fullyAuthorized;
    });

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


}
