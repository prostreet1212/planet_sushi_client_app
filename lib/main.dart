import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/login_screen.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/providers/login_state.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/otp_screen/otp_screen.dart';
import 'package:planet_sushi_client_app/features/testing/login_screen_test.dart';
import 'package:planet_sushi_client_app/features/testing/test_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/screens/login_screen/widgets/general_widgets/number_text_field.dart';
import 'features/main/presentation/screens/main_screen.dart';
import 'injection_container.dart' as di;



Future<void> main() async {
  await di.init();
  await Supabase.initialize(
    url: 'https://pyihjwclvypcaeifmbcu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB5aWhqd2NsdnlwY2FlaWZtYmN1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3ODI1MzIsImV4cCI6MjA5NTM1ODUzMn0.Wsfi8Rr7uTuXrJYcNLPQy7fZ-OM_m1f_GqxQ2d7JU4Q',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'RobotoCondensed',
      ),
      debugShowCheckedModeBanner: false,
      //home:const MainScreen(),
      //home:const AuthScreen(),
      //home: const LoginScreen(),
      home: const OtpScreen(phone: '+79532602744'),
    );
  }
}
