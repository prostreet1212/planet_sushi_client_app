import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/auth/data/datasource/auth_data_source.dart';
import 'package:planet_sushi_client_app/features/auth/data/models/user_model.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubits/add_user_cubit/add_user_cubit.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/cubits/add_user_cubit/add_user_state.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/name_screen/widgets/name_form_field.dart';
import 'package:planet_sushi_client_app/features/testing/pageview_app.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

class NameScreen extends StatefulWidget {
  const NameScreen({super.key,required this.phone});

  final String phone;

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _nameIsFilled=false;

  @override
  Widget build(BuildContext context) {
    // Получаем высоту клавиатуры
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    final double keyboardHeight = viewInsets.bottom;
    return BlocProvider<AddUserCubit>(
      create: (context)=> di.sl<AddUserCubit>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          //maintainBottomViewPadding: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isPortrait =
                  constraints.maxWidth < constraints.maxHeight;
              return Container(
                /*width: double.infinity,
                height: double.infinity,*/
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xff07aa55), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, isPortrait ? 0.7 : 1),
                  ),
                ),

                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: isPortrait ? 16 : 220,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: isPortrait
                            ? MediaQuery.sizeOf(context).height * 0.32
                            : 0,
                      ),
                      //SizedBox(height: constraints.maxHeight*0.3,),
                      Column(
                        children: [
                          const Text(
                            'Ваше имя',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          NameFormField(),
                          /*TextFormField(
                            controller: _nameController,
                            maxLength: 15,
                            keyboardType: TextInputType.name,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Zа-яА-ЯёЁ ]'),
                              ),
                            ],
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: 'Имя',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              counterText: '',
                              //prefixIconConstraints: BoxConstraints(minWidth: 0),
                              fillColor: Colors.white70,
                              filled: true,
                            ),
                            cursorColor: Colors.black,
                            enableInteractiveSelection: false,
                            onChanged: (value){
                              if (_nameController.text.length > 1 &&
                                  _nameIsFilled == false) {
                                setState(() {
                                  _nameIsFilled = true;
                                });
                              }else if(_nameController.text.length < 2 &&
                                  _nameIsFilled == true){
                                setState(() {
                                  _nameIsFilled = false;
                                });
                              }
                            },
                            validator: (value) {},
                          ),*/
                        ],
                      ),
                      Expanded(
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
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
