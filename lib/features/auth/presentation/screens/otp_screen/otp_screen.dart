import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/main_screen.dart';
import 'package:planet_sushi_client_app/features/testing/pageview_app.dart';
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
  bool otpIsValid=true;

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
        maintainBottomViewPadding: true,
        child: Container(
          //width: MediaQuery.of(context).size.width,
          width: double.infinity,
          height: double.infinity,
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
              mainAxisSize: MainAxisSize.min,
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
                SizedBox(
                  height: 100, //? место с запасом под form-сообщение снизу
                  child: Form(
                    key: _formKey,
                      child: MaterialPinFormField(
                        //scrollPadding: const EdgeInsets.all( 0), //add this line replace 50 with your required padding
                        pinController: pinController,
                        //formErrorSpace: 20,
                        formErrorStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                        length: 6,
                        theme: MaterialPinTheme(
                          showCursor: false,
                          cellSize: Size(45, 65),
                          borderWidth: 2,
                          borderColor: const Color(0xFF88b705),
                          filledBorderColor: const Color(0xFF88b705),

                          errorColor: Colors.black,
                          errorBorderColor: Colors.red,
                          errorFillColor: Colors.white,
                          errorAnimationDuration: Duration(milliseconds: 0),

                          completeBorderColor: Colors.purpleAccent,
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
                          if (value == null || value == '111111') {
                            pinController.triggerError();
                            return 'Введите другой код';
                            //return null;
                          }
                          if(!otpIsValid){
                            return 'Код неверный';
                          }
                          return null;
                        },
                        onSaved: (value) => print('Saved: $value'),
                        onCompleted: (pin) async{
                          print('completed $pin');

                          try{
                            // Подтверждаем код
                            final response = await Supabase.instance.client.auth.verifyOTP(
                              phone: widget.phone,
                              token: pinController.text.trim(),
                              type: OtpType.sms,
                            );
                            if (response.session != null) {
                              print(response.session!.user);
                              String error = 'auth completed';
                              print(error);
                              Navigator.push(context, MaterialPageRoute(builder: (c)=>MainScreen()));

                            }
                          }on AuthApiException catch(e){
                            String error = e.toString();
                            print('otp error: $error');
                            //if(e.statusCode=='403'){
                              otpIsValid=false;
                              pinController.triggerError();
                              _formKey.currentState?.validate();
                            //}
                          } catch(e){
                            String error = e.toString();
                            print('otp error: $error');
                          }
                        },
                        onChanged: (pin) {
                          if(!otpIsValid){
                            otpIsValid=true;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              pinController.clear();
                            });
                            pinController.clearError();
                            _formKey.currentState?.clearError();
                          }
                          print('changed');
                        },
                      ),

                  ),
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
        ),
      ),
    );
  }
}
