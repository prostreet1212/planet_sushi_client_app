import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ElevatedButton(onPressed: () {}, child: Text('Проверить код')),
            Text(error),
          ],
        ),
      ),
    );
  }
}
