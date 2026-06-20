import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneInfoHorizontal extends StatefulWidget {
   PhoneInfoHorizontal({super.key, required this.formKey, required this.phoneController, required this.phoneMaskFormatter,required this.sendCodeEnabled});
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final MaskTextInputFormatter phoneMaskFormatter;
  bool sendCodeEnabled;

  @override
  State<PhoneInfoHorizontal> createState() => _PhoneInfoHorizontalState();
}

class _PhoneInfoHorizontalState extends State<PhoneInfoHorizontal> {
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
              Form(
                key: widget.formKey,
                child: TextFormField(
                  controller: widget.phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [widget.phoneMaskFormatter],
                  onChanged: (value) {
                    if (widget.phoneController.text.length >
                        14 &&
                        widget.sendCodeEnabled == false) {
                      setState(() {
                        widget.sendCodeEnabled = true;
                        var number = widget.phoneMaskFormatter
                            .getUnmaskedText();
                        print('номер ${number}');
                      });
                    } else if (widget.phoneController
                        .text
                        .length <=
                        14 &&
                        widget.sendCodeEnabled == true) {
                      setState(() {
                        widget.sendCodeEnabled = false;
                        var number = widget.phoneMaskFormatter
                            .getUnmaskedText();
                        print('номер ${number}');
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Номер телефона',
                    hintText: '(999) 999-99-99',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                    prefix: Text('+7'),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: const Icon(Icons.call),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 0,
                    ),
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
