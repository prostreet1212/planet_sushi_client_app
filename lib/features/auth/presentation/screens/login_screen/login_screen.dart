import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/providers/login_state.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/widgets/phone_info_horizontal.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/widgets/phone_info_vertical.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/widgets/send_code_button.dart';
import 'package:provider/provider.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

import '../../cubits/auth_cibit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String error = '';
  late LoginState _loginState;

  @override
  void initState() {
    super.initState();
    _loginState = di.sl<LoginState>();

    //_loginState.phoneController.text='9532602744';
  }

  @override
  void dispose() {
    //context.read<LoginState>().dispose();
    di.sl<LoginState>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_loginState = di.sl<LoginState>();
    debugPrint('Строитель логинскрин');
    // Получаем высоту клавиатуры
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    _loginState.setKeyboardHeight(viewInsets.bottom);
    //final double keyboardHeight = viewInsets.bottom;

    return BlocProvider<AuthCubit>(
      create: (context)=>di.sl<AuthCubit>(),
        child:  Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: ChangeNotifierProvider.value(
              value: _loginState,
              //create: (context) => di.sl<LoginState>(),
              //create: (context) => context.read<LoginState>(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  debugPrint('Строитель логинскринлайоутбилдер');
                  //final loginState = context.read<LoginState>();
                  /*final bool isPortrait =
                      constraints.maxWidth < constraints.maxHeight;*/
                  _loginState.updateSizes(
                    constraints.maxWidth < constraints.maxHeight,
                    constraints,
                   // _loginState.keyboardHeight,
                  );
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xff07aa55), Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment(0.0, _loginState.isPortrait ? 0.7 : 1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Планета суши',
                            style: TextStyle(fontSize: 30, color: Colors.black,fontWeight: FontWeight.w600),
                          ),
                          _loginState.isPortrait
                              ? const PhoneInfoVertical()
                              : const PhoneInfoHorizontal(),
                          const SendCodeButton(),//не const

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

    );
  }
}
