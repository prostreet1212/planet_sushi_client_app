import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/data/datasource/auth_data_source.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubits/otp_cubit/otp_cubit.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/login_screen.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/login_screen/providers/login_state.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/name_screen/name_screen.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/otp_screen/otp_screen.dart';
import 'package:planet_sushi_client_app/features/testing/login_screen_test.dart';
import 'package:planet_sushi_client_app/features/testing/test_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/cubits/auth_cibit/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen/widgets/general_widgets/number_text_field.dart';
import 'features/main/presentation/screens/main_screen.dart';
import 'injection_container.dart' as di;



Future<void> main() async {
  await Supabase.initialize(
    url: 'https://pyihjwclvypcaeifmbcu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB5aWhqd2NsdnlwY2FlaWZtYmN1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3ODI1MzIsImV4cCI6MjA5NTM1ODUzMn0.Wsfi8Rr7uTuXrJYcNLPQy7fZ-OM_m1f_GqxQ2d7JU4Q',
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return/* MultiProvider(providers: [
     // BlocProvider<AuthCubit>(create: (context)=>di.sl<AuthCubit>()),
      //BlocProvider<OtpCubit>(create: (context)=>di.sl<OtpCubit>()),
      //Provider(create: (context)=>di.sl<AuthDataSource>())
    ],
      child: );*/
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // Настраиваем цветовую схему выделения
          textSelectionTheme: TextSelectionThemeData(
            //selectionHandleColor: Colors.blue, // Цвет вашей "капельки"
            //cursorColor: Colors.blue,          // Цвет самого курсора
            //selectionColor: Colors.blue, // Цвет фона выделенного текста
          ),
          colorScheme: .fromSeed(seedColor: Colors.yellow),
          useMaterial3: false,
          fontFamily: 'RobotoCondensed',
        ),
        debugShowCheckedModeBanner: false,
        //home:const MainScreen(),
        //home:const AuthScreen(),
        home: const LoginScreen(),
        //home: const OtpScreen(phone: '+79532602744'),
        //home: const NameScreen(phone: '+79532602744'),
      );
  }
}
