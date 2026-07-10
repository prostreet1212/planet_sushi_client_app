import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubits/add_user_cubit/add_user_cubit.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/name_screen/providers/name_state.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/name_screen/widgets/add_user_button.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/name_screen/widgets/name_form_field.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;
import 'package:provider/provider.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key,});

  //final String phone;

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {


  @override
  Widget build(BuildContext context) {
    debugPrint('строитель нэймскрин');
    final nameState = di.sl<NameState>();
    // Получаем высоту клавиатуры
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    di.sl<NameState>().setKeyboardHeight(viewInsets.bottom);
    //nameState.setKeyboardHeight(viewInsets.bottom);
    //final double keyboardHeight = viewInsets.bottom;
    return BlocProvider<AddUserCubit>(
      create: (context)=>di.sl<AddUserCubit>(),
      child: ChangeNotifierProvider.value(
        value:di.sl<NameState>(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            //maintainBottomViewPadding: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                nameState.setIsPortrait(constraints.maxWidth < constraints.maxHeight);
               /* final bool isPortrait =
                    constraints.maxWidth < constraints.maxHeight;*/
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xff07aa55), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment(0.0, nameState.isPortrait ? 0.7 : 1),
                    ),
                  ),

                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: nameState.isPortrait ? 16 : 220,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: nameState.isPortrait
                              ? MediaQuery.sizeOf(context).height * 0.32
                              : 0,
                        ),
                        const Column(
                          children: [
                            Text(
                              'Ваше имя',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            NameFormField(),
                          ],
                        ),
                        const AddUserButton(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
