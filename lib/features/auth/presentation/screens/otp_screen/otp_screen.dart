import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/otp_screen/providers/otp_phone_state.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/otp_screen/widgets/otp_form_field.dart';

import '../../../../../injection_container.dart' as di;
import '../../cubits/otp_cubit/otp_cubit.dart';


class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key,/* required this.phone*/});

 // final String phone;

  @override
  Widget build(BuildContext context) {
    OtpPhoneState otpPhoneState = di.sl<OtpPhoneState>();
    debugPrint('Строитель отпскрин');
    return BlocProvider<OtpCubit>(
      create: (context)=>di.sl<OtpCubit>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            //width: MediaQuery.of(context).size.width,
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff07aa55), Colors.white],
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
                    'Отправили его на номер ${otpPhoneState.phone}.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'RobotoCondensedRegular',
                    ),
                  ),
                  const SizedBox(height: 10),
                   OtpFormField(/*phone: phone*/),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
