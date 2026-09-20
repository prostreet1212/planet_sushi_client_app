import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:planet_sushi_client_app/core/routers/app_router.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/name_screen/name_screen.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/otp_screen/providers/otp_phone_state.dart';
import 'package:planet_sushi_client_app/features/profile/datasource/profile_local_data_source.dart';

import '../../../../../main/presentation/screens/main_screen.dart';
import '../../../../data/models/user_model.dart';
import '../../../cubits/otp_cubit/otp_cubit.dart';
import '../../../cubits/otp_cubit/otp_state.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

class OtpFormField extends StatefulWidget {
  //final String phone;

  const OtpFormField({super.key, /*required this.phone*/});

  @override
  State<OtpFormField> createState() => _OtpFormFieldState();
}

class _OtpFormFieldState extends State<OtpFormField> {
  final pinController = PinInputController();
  final _formKey = GlobalKey<FormState>();
  bool otpIsValid = true;
  //для блокировки ввода пока грузится
  bool _readOnly = false;

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Строитель филдотпскрин');
    OtpPhoneState otpPhoneState = di.sl<OtpPhoneState>();
    return BlocListener<OtpCubit, OtpState>(
      listener: (context, otpState)async {
        if (otpState is OtpError) {
          otpIsValid = false;
          pinController.triggerError();
          //await Future.delayed(Duration(seconds: 2));
          setState(() {
            _readOnly = false;
          });
          _formKey.currentState?.validate();
        } else if (otpState is OtpSuccess) {
          setState(() {
            _readOnly = false;
          });
         /* Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const MainScreen()),
          );*/
          //context.router.push(const MainRoute());
          context.router.popUntilRoot();
        }else if(otpState is OtpNext){
          setState(() {
            _readOnly = false;
          });
          //di.sl<OtpPhoneState>().setPhone(widget.phone);
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (c) =>const NameScreen()),
          );*/
          context.router.push(const NameRoute());
        }
      },
      child: SizedBox(
        height: 100, //? место с запасом под form-сообщение снизу
        child: Form(
          key: _formKey,
          child: MaterialPinFormField(
            //scrollPadding: const EdgeInsets.all( 0), //add this line replace 50 with your required padding
            pinController: pinController,
            //enabled: otpIsValid,
            readOnly: _readOnly,

            //formErrorSpace: 20,
            formErrorStyle: TextStyle(fontSize: 16, color: Colors.red),
            length: 6,
            theme: const MaterialPinTheme(
              showCursor: false,
              cellSize: Size(45, 65),
              borderWidth: 2,
              borderColor: Color(0xFF88b705),
              filledBorderColor: Color(0xFF88b705),

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
              if (!otpIsValid) {
                return 'Код неверный';
              }
              return null;
            },
            onSaved: (value) => print('Saved: $value'),
            onCompleted: (pin) async {
              print('completed $pin');
              setState(() {
                _readOnly = true;
              });
              context.read<OtpCubit>().verifyOtp(
                otpPhoneState.phone,
                pinController.text.trim(),
              );

              /*try{
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
                          }*/
            },
            onChanged: (pin) {
              if (!otpIsValid) {
                otpIsValid = true;
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
    );
  }
}
