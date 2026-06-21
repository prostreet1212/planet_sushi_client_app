import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/widgets/phone_info_horizontal.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/widgets/phone_info_vertical.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String error = '';
  final _phoneController = TextEditingController();
  bool sendCodeEnabled = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Создайте маску
  var phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    print('Строитель логинскрин');
    // Получаем высоту клавиатуры
    final viewInsets = MediaQuery.of(context).viewInsets;
    final keyboardHeight = viewInsets.bottom;
    return //рабочий вертикальный экран
      LayoutBuilder(
        builder: (context, constraints) {
          final isPortrait = constraints.maxWidth < constraints.maxHeight;

          final viewInsets = MediaQuery
              .of(context)
              .viewInsets;
          final isKeyboardVisible = viewInsets.bottom > 0;


          return Scaffold(
            //resizeToAvoidBottomInset: false,
            resizeToAvoidBottomInset: isPortrait ? false : false,
            //backgroundColor: Colors.green,
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  //image: DecorationImage(image: AssetImage('assets/images/grey_fon1.jpg'),fit: BoxFit.cover)
                  gradient: LinearGradient(
                    colors: [Color(0xff07aa55), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment(
                      0.0,
                      isPortrait ? 0.7 : 1,
                    ),
                  ),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                     /* SingleChildScrollView(
                          child:*/ Column(

                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Планета суши',
                                style: TextStyle(fontSize: 30, color: Colors.black),
                              ),
                              isPortrait
                                  ?
                              PhoneInfoVertical(formKey: _formKey,
                                phoneController: _phoneController,
                                phoneMaskFormatter: phoneMaskFormatter,
                                sendCodeEnabled: sendCodeEnabled,)
                                  : PhoneInfoHorizontal(formKey: _formKey,
                                phoneController: _phoneController,
                                phoneMaskFormatter: phoneMaskFormatter,
                                sendCodeEnabled: sendCodeEnabled,),
                            ],
                          ),

                      //),
                      //SizedBox на expanded?
                      /*Expanded(
                                //height: height * 0.373,
                                child: */Align(
                        alignment: AlignmentGeometry.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: isPortrait ? keyboardHeight : 0,
                          ),
                          child: ElevatedButton(
                            onPressed: sendCodeEnabled ? () {} : null,
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(constraints.maxWidth / 2, 54),
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
                          ),
                        ),
                      ),
                      //)
                    ],
                  ),
                ),

              ),
            ),
          );
        },
      );





    //с отправкой кода
    /*Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await Supabase.instance.client.auth.signInWithOtp(
                    phone: '+79532602744',
                  );
                } catch (e) {
                  setState(() {
                    error = e.toString();
                    print(error);
                  });
                }
              },
              child: Text('Отправить код'),
            ),
            TextField(
              controller: _otpController,
            ),
            ElevatedButton(onPressed: () async{
              try{
                // Подтверждаем код
                final response = await Supabase.instance.client.auth.verifyOTP(
                  phone: '+79532602744',
                  token: _otpController.text.trim(),
                  type: OtpType.sms,
                );
                if (response.session != null) {
                  print(response.session!.user);
                  setState(() {
                    error = 'auth completed';
                    print(error);
                  });
                }
              }catch(e){
                setState(() {
                  error = e.toString();
                  print(error);
                });
              }

            }, child: Text('Проверить код')),
            Text(error),
          ],
        ),
      ),
    );*/
  }
}
