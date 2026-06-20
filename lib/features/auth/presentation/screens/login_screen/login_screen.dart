import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
    return //рабочий вертикальный экран
      LayoutBuilder(
        builder: (context, constraints) {
          final isPortrait = constraints.maxWidth < constraints.maxHeight;

          final viewInsets = MediaQuery.of(context).viewInsets;
          final isKeyboardVisible = viewInsets.bottom > 0;

          // Вычисляем доступную высоту с учетом клавиатуры
         // final availableHeight =isPortrait&&isKeyboardVisible? constraints.maxHeight - viewInsets.bottom:constraints.maxHeight;

          return Scaffold(
            //resizeToAvoidBottomInset: false,
            resizeToAvoidBottomInset:isPortrait?true: false,
            //backgroundColor: Colors.green,
            body: SafeArea(
              child:Container(

                decoration: BoxDecoration(
                  //image: DecorationImage(image: AssetImage('assets/images/grey_fon1.jpg'),fit: BoxFit.cover)
                  gradient: LinearGradient(
                    colors: [Color(0xff07aa55), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment(
                      0.0,
                      isPortrait  ? 0.7 : 1,
                    ),
                  ),
                ),

                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                      child: Column(

                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Планета суши',
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                          isPortrait
                              ?
                              PhoneInfoVertical(formKey: _formKey, phoneController: _phoneController, phoneMaskFormatter: phoneMaskFormatter, sendCodeEnabled: sendCodeEnabled,)
                              :  Row(
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
                                        key: _formKey,
                                        child: TextFormField(
                                          controller: _phoneController,
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [phoneMaskFormatter],
                                          onChanged: (value) {
                                            if (_phoneController.text.length >
                                                14 &&
                                                sendCodeEnabled == false) {
                                              setState(() {
                                                sendCodeEnabled = true;
                                                var number = phoneMaskFormatter
                                                    .getUnmaskedText();
                                                print('номер ${number}');
                                              });
                                            } else if (_phoneController
                                                .text
                                                .length <=
                                                14 &&
                                                sendCodeEnabled == true) {
                                              setState(() {
                                                sendCodeEnabled = false;
                                                var number = phoneMaskFormatter
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
                                                          ),



                          //SizedBox на expanded?
                                             Expanded(
                            //height: height * 0.373,
                            child: Align(
                              alignment: AlignmentGeometry.bottomCenter,
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
                          )
                        ],
                      ),
                    ),

               ),
              ),
          );
        },
      );


    //orientationbuilder
    /*Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Планета суши', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                    SizedBox(height: orientation == Orientation.landscape ? 20 : 50),

                    if (orientation == Orientation.landscape)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset('assets/images/panda_auth1.png', width: 180),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  'Войдите в профиль или зарегистрируйтесь по номеру телефона',
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: 'Номер телефона',
                                    hintText: '+7 (999) 999-99-99',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: const Icon(Icons.phone),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Image.asset('assets/images/panda_auth1.png', width: 220),
                          SizedBox(height: 36),
                          Text(
                            'Войдите в профиль или зарегистрируйтесь по номеру телефона',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Номер телефона',
                              hintText: '+7 (999) 999-99-99',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.phone),
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 54),
                        backgroundColor: const Color(0xFF3498DB),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    )*/

    //layoutnbuilder
    /* Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Планета суши', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                        SizedBox(height: isLandscape ? 20 : 50),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: isLandscape
                                ? [
                              Expanded(
                                flex: 1,
                                child: Image.asset('assets/images/panda_auth1.png', width: 180),
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Text(
                                      'Войдите в профиль или зарегистрируйтесь по номеру телефона',
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: 'Номер телефона',
                                        hintText: '+7 (999) 999-99-99',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        prefixIcon: const Icon(Icons.phone),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                                : [
                              Expanded(
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/panda_auth1.png', width: 220),
                                    SizedBox(height: 36),
                                    Text(
                                      'Войдите в профиль или зарегистрируйтесь по номеру телефона',
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: 'Номер телефона',
                                        hintText: '+7 (999) 999-99-99',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        prefixIcon: const Icon(Icons.phone),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 54),
                            backgroundColor: const Color(0xFF3498DB),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );*/

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
