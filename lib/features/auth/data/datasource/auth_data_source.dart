
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDataSource {
  final Supabase supabase;

  AuthDataSource({required this.supabase});




  Future<Either<String,Null>> sendCode(String number)async{
    String phoneNumber='+7${number}';
    debugPrint(phoneNumber);
    try {
      await supabase.client.auth.signInWithOtp(
        phone: phoneNumber,
      );
      return Right(null);
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(phone: phoneNumber,)));
    } catch (e) {
      String error = e.toString();
      debugPrint(error);
      return Left(error);
    }
  }
  Future<Either<String,Null>> verifyOtp(String number,String token)async{
    try{
      // Подтверждаем код
      final response = await Supabase.instance.client.auth.verifyOTP(
        phone: number,
        token: token,
        type: OtpType.sms,
      );
      if (response.session != null) {
        print(response.session!.user);
        String error = 'auth completed';
        print(error);
        return Right(null);
        //Navigator.push(context, MaterialPageRoute(builder: (c)=>MainScreen()));
      }
      return Left('');
    }on AuthApiException catch(e){
      String error = e.toString();
      print('otp error: $error');
      //if(e.statusCode=='403'){
      return Left(error);
     /* otpIsValid=false;
      pinController.triggerError();
      _formKey.currentState?.validate();*/
      //}
    } catch(e){
      String error = e.toString();
      print('otp error: $error');
      return Left(error);
    }

  }


}