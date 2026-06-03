import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String error = '';
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      //backgroundColor: Colors.green,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            //image: DecorationImage(image: AssetImage('assets/images/grey_fon1.jpg'),fit: BoxFit.cover)
            gradient: LinearGradient(
              colors: [?Color(0xff07aa55), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment(0.0, 0.7),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Планета суши',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        //fontWeight: FontWeight.w600,
                        fontFamily: 'RobotoCondensed'
                      ),
                    ),
                    Container(
                      //height: 250,
                      //flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/panda_auth1.png',
                              width: 220,
                            ),
                            SizedBox(height: 36),
                            Text(
                              'Войдите в профиль или зарегистрируйтесь по номеру телефона',
                              style: TextStyle(fontSize: 20,
                                  fontFamily: 'RobotoCondensed'),
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
                                fillColor: Colors.white70,
                                filled: true
                                //prefixIcon: Text('+7'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //либо заменить на expanded?
                    SizedBox(
                      height: height * 0.373,
                      child: Align(
                        alignment: AlignmentGeometry.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(width / 2, 54),
                            backgroundColor: const Color(0xFF88b705),
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
                      ),
                    ),

                    //
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

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
