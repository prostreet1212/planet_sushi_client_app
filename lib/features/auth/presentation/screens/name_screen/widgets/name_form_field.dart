import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planet_sushi_client_app/features/auth/presentation/screens/name_screen/providers/name_state.dart';
import 'package:provider/provider.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

class NameFormField extends StatefulWidget {
  const NameFormField({super.key});

  @override
  State<NameFormField> createState() => _NameFormFieldState();
}

class _NameFormFieldState extends State<NameFormField> {

  late NameState nameState;

  @override
  void initState() {
    super.initState();
    nameState = di.sl<NameState>();
  }

  @override
  Widget build(BuildContext context) {

    return TextFormField(
        controller: nameState.nameController,
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
          if (nameState.nameController.text.length > 1 &&
              nameState.nameIsFilled == false) {
            setState(() {
              nameState.setNameIsFilled(true);
            });
          }else if(nameState.nameController.text.length < 2 &&
              nameState.nameIsFilled == true){
            setState(() {
              nameState.setNameIsFilled(false);
            });
          }
        },
        validator: (value) {},
      );
  }
}


