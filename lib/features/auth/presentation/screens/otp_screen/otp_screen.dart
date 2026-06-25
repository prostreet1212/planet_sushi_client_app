

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});
  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xff07aa55), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment(0.0, 0.7),
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Код из СМС',
                  style: TextStyle(fontSize: 30, color: Colors.black, ),
                ),
                 SizedBox(
                   height: 10,
                 ),
                 Text(
                  'Отправили его на номер ${widget.phone}',
                  style: TextStyle(fontSize: 18, color: Colors.black,fontFamily: 'RobotoCondensedRegular'),
                ),
                SizedBox(
                  height: 10,
                ),
               /* TextField(
                  controller: _otpController,
                ),*/
                OtpTextField(
                  numberOfFields: 6,
                  borderColor: Color(0xFF512DA8),
                  textStyle: TextStyle(color: Colors.red,fontSize: 24),
                  contentPadding: EdgeInsets.all(8),
                  showCursor: false,
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode){
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text("Verification Code"),
                            content: Text('Code entered is $verificationCode'),
                          );
                        }
                    );
                  }, // end onSubmit
                ),
                SizedBox(
                  height: 10,
                ),
                /*ElevatedButton(
                  onPressed: () async {
                    try{
                      // Подтверждаем код
                      final response = await Supabase.instance.client.auth.verifyOTP(
                        phone: widget.phone,
                        token: _otpController.text.trim(),
                        type: OtpType.sms,
                      );
                      if (response.session != null) {
                        print(response.session!.user);
                          String error = 'auth completed';
                          print(error);

                      }
                    }catch(e){
                        String error = e.toString();
                        print(error);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width / 2, 54),
                    backgroundColor: const Color(0xFF88b705),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'Окай',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),*/


              ],
            ),

        ),
      )),
    );
  }
}
