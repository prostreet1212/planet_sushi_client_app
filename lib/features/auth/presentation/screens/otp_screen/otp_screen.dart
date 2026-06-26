import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  //final TextEditingController _otpController = TextEditingController();

  final pinController = PinInputController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xff07aa55), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment(0.0, 0.7),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Код из СМС',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Отправили его на номер ${widget.phone}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'RobotoCondensedRegular',
                    ),
                  ),
                  SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: MaterialPinFormField(
                      pinController: pinController,
                        //formErrorSpace: 20,
                        formErrorStyle: TextStyle(fontSize: 16,),
                        length: 6,
                      theme: MaterialPinTheme(
                        showCursor: false,
                        cellSize: Size(45,65),
                        borderWidth: 2,
                        borderColor: const Color(0xFF88b705),
                        filledBorderColor: const Color(0xFF88b705),
                        focusedBorderColor: Colors.orange,
                        fillColor: Colors.white,
                        focusedFillColor: Colors.white,
                        filledFillColor: Colors.white,
                        // Animation
                        entryAnimation: MaterialPinAnimation.fade,
                        animationDuration: Duration(milliseconds: 150),
                        animationCurve: Curves.easeOut,
                      ),
                      validator: (value) {
                        if (value == null || value.length == 6) {
                          return 'Please enter all 6 digits';
                        }
                        return null;
                      },
                      onSaved: (value) => print('Saved: $value'),
                      onCompleted: (pin){
                          print('completed $pin');
                          _formKey.currentState?.validate();
                          //pinController.triggerError();
                      },
                      onChanged:(pin){
                          print('changed');
                      },
                    ),
                  )

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
        ),
      ),
    );
  }
}
