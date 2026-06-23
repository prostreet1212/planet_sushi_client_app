import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:planet_sushi_client_app/main.dart';

import 'general_widgets/number_text_field.dart';

class PhoneInfoHorizontal extends StatelessWidget {
    const PhoneInfoHorizontal({super.key});



  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Image.asset(
            'assets/images/panda_auth1.png',
            width: 180,
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Войдите в профиль или зарегистрируйтесь по номеру телефона',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              NumberTextField(),
              /*SizedBox(height: 20),
                                      ElevatedButton(
                                                onPressed: sendCodeEnabled ? () {} : null,
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(width / 2, 54),
                                                  backgroundColor: const Color(
                                                    0xFF88b705,
                                                  ),
                                                  foregroundColor: Colors.white,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(
                                                      32,
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Отправить код',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
