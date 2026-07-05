
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDataSource {


  Future<Either<String,Null>> sendCode(String number)async{
    String phoneNumber='+7${number}';
    debugPrint(phoneNumber);
    try {
      await Supabase.instance.client.auth.signInWithOtp(
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



}