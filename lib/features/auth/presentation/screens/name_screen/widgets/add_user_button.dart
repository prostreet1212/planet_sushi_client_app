import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/user_model.dart';
import '../../../cubits/add_user_cubit/add_user_cubit.dart';
import '../../../cubits/add_user_cubit/add_user_state.dart';
/*
class AddUserButton extends StatelessWidget {
  const AddUserButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: isPortrait ? keyboardHeight : 0,
        ),
        child: Align(
          alignment: AlignmentGeometry.bottomCenter,
          child: BlocListener<AddUserCubit,AddUserState>(
            listener: (context,state){
              if (state is AddUserSuccess) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const MyHomePage()), (route)=>false);
              }else if(state is AddUserError){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка ${state.message}'))
                );
              }
            },
            child: ElevatedButton(
              onPressed:_nameIsFilled? () {
                final user = UserModel(phone: widget.phone, name: _nameController.text);
                di.sl<AuthDataSource>().createUser(user);
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
*/