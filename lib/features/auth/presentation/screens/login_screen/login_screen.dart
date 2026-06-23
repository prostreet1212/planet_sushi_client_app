import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/providers/login_state.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/widgets/general_widgets/number_text_field.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/widgets/phone_info_horizontal.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/widgets/phone_info_vertical.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/widgets/send_code_button.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String error = '';

  @override
  void dispose() {
    di.sl<LoginState>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Строитель логинскрин');
    // Получаем высоту клавиатуры
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    final double keyboardHeight = viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => di.sl<LoginState>(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              debugPrint('Строитель логинскринлайоутбилдер');
              final loginState = context.read<LoginState>();
              final bool isPortrait =
                  constraints.maxWidth < constraints.maxHeight;
              loginState.updateSizes(
                isPortrait,
                constraints,
                keyboardHeight,
              );
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xff07aa55), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, isPortrait ? 0.7 : 1),
                  ),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Планета суши',
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                      isPortrait
                          ? const PhoneInfoVertical()
                          : const PhoneInfoHorizontal(),
                      SendCodeButton(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
