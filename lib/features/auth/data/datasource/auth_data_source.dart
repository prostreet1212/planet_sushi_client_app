import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

enum AuthStatus { success, next }

class AuthDataSource {
  final Supabase supabase;

  AuthDataSource({required this.supabase});

  Future<Either<String, Null>> sendCode(String number) async {
    String phoneNumber = '+7$number';
    debugPrint(phoneNumber);
    try {
      await supabase.client.auth.signInWithOtp(phone: phoneNumber);
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
      final response = await supabase.client.auth.verifyOTP(
        phone: number,
        token: token,
        type: OtpType.sms,
      );
      if (response.session != null) {
        print(response.session!.user);
        String message = 'auth completed';
        print(message);
        final Map<String, dynamic>? data = await supabase.client
            .from('users')
            .select()
            .eq('id', response.session!.user.id)
            .maybeSingle();
        if (data == null) {
          return const Right(null);
        }else{
          final UserModel user = UserModel.fromJson(data);
          return  Right(user);
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


}
