import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/core/routers/app_router.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/otp_screen/otp_screen.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/otp_screen/providers/otp_phone_state.dart';


import '../../../cubits/auth_cubit/auth_cubit.dart';
import '../../../cubits/auth_cubit/auth_state.dart';
import '../providers/login_state.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

class SendCodeButton extends StatelessWidget {
  const SendCodeButton({
    super.key ,});



  @override
  Widget build(BuildContext context) {
    final loginState = context.watch<LoginState>();
    print(loginState.keyboardHeight);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: loginState.isPortrait ?loginState.keyboardHeight : 0,
        ),
        child: Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: BlocListener<AuthCubit,AuthState>(
              /*  buildWhen: (oldState,newState){
              return false;
            },*/
                child: /*(context,_){

                print('строитель кнопка отправить');
            return*/ ElevatedButton(
                  onPressed: loginState.sendCodeEnabled ? () async{
                    context.read<AuthCubit>().sendCode(loginState.phoneMaskFormatter.getUnmaskedText());
                    /* String phoneNumber='+7${loginState.phoneMaskFormatter.getUnmaskedText()}';
                debugPrint(phoneNumber);
                try {
                  await Supabase.instance.client.auth.signInWithOtp(
                    phone: phoneNumber,
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(phone: phoneNumber,)));
                } catch (e) {
                  String error = e.toString();
                  debugPrint(error);

                }*/
                  } : null,
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(loginState.constraints.maxWidth / 2, 54),
                    backgroundColor: const Color(0xFF88b705),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'Отправить код',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                //},
                listener: (context,state){
                  if(state is AuthSuccess){
                    String phoneNumber='+7${loginState.phoneMaskFormatter.getUnmaskedText()}';
                     di.sl<OtpPhoneState>().setPhone(phoneNumber);
                    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OtpScreen()), (route) => false, );
                  //context.router.replaceAll([const OtpRoute()]);
                  context.router.push(const OtpRoute());
                  }else if(state is AuthError){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка ${state.message}'))
                    );

                  }

                })
        ),
      ),
    );
  }
}
