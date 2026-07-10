import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/name_screen/providers/name_state.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/otp_screen/providers/otp_phone_state.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/main_screen.dart';

import '../../../../../../injection_container.dart' as di;
import '../../../../data/models/user_model.dart';
import '../../../cubits/add_user_cubit/add_user_cubit.dart';
import '../../../cubits/add_user_cubit/add_user_state.dart';

class AddUserButton extends StatelessWidget {

  const AddUserButton({super.key,});

  @override
  Widget build(BuildContext context) {
    final nameState = context.watch<NameState>();
    final otpPhoneState = di.sl<OtpPhoneState>();
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: nameState.isPortrait ? nameState.keyboardHeight : 0,
        ),
        child: Align(
          alignment: AlignmentGeometry.bottomCenter,
          child: BlocListener<AddUserCubit,AddUserState>(
            listener: (context,state){
              if (state is AddUserSuccess) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const MainScreen()), (route)=>false);
              }else if(state is AddUserError){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка ${state.message}'))
                );
              }
            },
            child: ElevatedButton(
              onPressed:nameState.nameIsFilled? () {
                final user = UserModel(phone: otpPhoneState.phone, name: nameState.nameController.text);
                //di.sl<AuthDataSource>().createUser(user);
                //di.sl<AddUserCubit>().addUser(user);
                context.read<AddUserCubit>().addUser(user);
              }:null,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(205, 54),
                backgroundColor: const Color(0xFF88b705),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: const Text(
                'Завершить',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          //},
        ),
      ),
    );
  }
}
