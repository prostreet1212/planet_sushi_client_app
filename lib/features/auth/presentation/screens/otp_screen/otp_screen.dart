

import 'package:flutter/material.dart';
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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Код из СМС',
                  style: TextStyle(fontSize: 30, color: Colors.black,fontWeight: FontWeight.bold),
                ),
                 SizedBox(
                   height: 10,
                 ),
                 Text(
                  'Отправили его на номер ${widget.phone}',
                  style: TextStyle(fontSize: 16, color: Colors.black,),
                ),
                TextField(
                  controller: _otpController,
                ),
                ElevatedButton(
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
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
