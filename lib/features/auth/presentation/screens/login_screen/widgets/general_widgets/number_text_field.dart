import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../injection_container.dart' as di;
import '../../providers/login_state.dart';


class NumberTextField extends StatelessWidget {
  const NumberTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final loginState = context.watch<LoginState>();
    return Form(
      key: loginState.formKey,
      child: TextFormField(
        controller: loginState.phoneController,
        keyboardType: TextInputType.phone,
        inputFormatters: [loginState.phoneMaskFormatter],
        onChanged: (value) {
          if (loginState.phoneController.text.length > 14 &&
              loginState.sendCodeEnabled == false) {
            loginState.updateSendCodeEnabled(true);
            var number = loginState.phoneMaskFormatter.getUnmaskedText();
            print('номер ${number}');
          } else if (loginState.phoneController.text.length <= 14 &&
              loginState.sendCodeEnabled == true) {
            loginState.updateSendCodeEnabled(false);
            var number = loginState.phoneMaskFormatter.getUnmaskedText();
            print('номер ${number}');
          }
        },
        decoration: InputDecoration(
          labelText: 'Номер телефона',
          hintText: '(999) 999-99-99',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefix: Text('+7'),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: const Icon(Icons.call),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0),
          fillColor: Colors.white70,
          filled: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Введите номер телефона';
          }
          return null;
        },
      ),
    );
  }
}
