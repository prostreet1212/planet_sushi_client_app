import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/widgets/general_widgets/number_text_field.dart';
import 'package:planet_sushi_client_app/main.dart';

class PhoneInfoVertical extends StatelessWidget {
  const PhoneInfoVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/panda_auth1.png', width: 220),
          const SizedBox(height: 36),
          Text(
            'Войдите в профиль или зарегистрируйтесь по номеру телефона',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const NumberTextField(),
        ],
      ),
    );
    ;
  }
}
