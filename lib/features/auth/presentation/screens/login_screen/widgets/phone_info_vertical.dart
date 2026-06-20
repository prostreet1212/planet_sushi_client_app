import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneInfoVertical extends StatefulWidget {
   PhoneInfoVertical({super.key,required this.formKey, required this.phoneController, required this.phoneMaskFormatter, required this.sendCodeEnabled});
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final MaskTextInputFormatter phoneMaskFormatter;
   bool sendCodeEnabled;


  @override
  State<PhoneInfoVertical> createState() => _PhoneInfoVerticalState();
}

class _PhoneInfoVerticalState extends State<PhoneInfoVertical> {
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
          Form(
            key: widget.formKey,
            child: TextFormField(
              controller: widget.phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [widget.phoneMaskFormatter],
              onChanged: (value) {
                if (widget.phoneController.text.length > 14 &&
                    widget.sendCodeEnabled == false) {
                  setState(() {
                    widget.sendCodeEnabled = true;
                    var number = widget.phoneMaskFormatter.getUnmaskedText();
                    print('номер ${number}');
                  });
                } else if (widget.phoneController.text.length <= 14 &&
                    widget.sendCodeEnabled == true) {
                  setState(() {
                    widget.sendCodeEnabled = false;
                    var number = widget.phoneMaskFormatter.getUnmaskedText();
                    print('номер ${number}');
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Номер телефона',
                hintText: '(999) 999-99-99',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
          ),
        ],
      ),
    );
    ;
  }
}
