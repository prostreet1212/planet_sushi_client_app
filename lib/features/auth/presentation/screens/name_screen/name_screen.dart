import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  TextEditingController _nameController = TextEditingController();
  bool _nameIsFilled=false;

  @override
  Widget build(BuildContext context) {
    // Получаем высоту клавиатуры
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    final double keyboardHeight = viewInsets.bottom;
    return Scaffold(
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
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _nameController,
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
                            //prefixIconConstraints: BoxConstraints(minWidth: 0),
                            fillColor: Colors.white70,
                            filled: true,
                          ),
                          cursorColor: Colors.black,
                          enableInteractiveSelection: false,
                          validator: (value) {},
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: isPortrait ? keyboardHeight : 0,
                        ),
                        child: Align(
                          alignment: AlignmentGeometry.bottomCenter,
                          child: ElevatedButton(
                            onPressed:_nameIsFilled? () {}:null,
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
    );
  }
}
