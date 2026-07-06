import 'package:flutter/material.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  @override
  Widget build(BuildContext context) {
    // Получаем высоту клавиатуры
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    final double keyboardHeight = viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        maintainBottomViewPadding: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xff07aa55), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment(0.0,  0.7 ),
              ),
            ),

            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 10,),
                 Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     const Text(
                       'Ваше имя',
                       style: TextStyle(fontSize: 30, color: Colors.black,fontWeight: FontWeight.w600),
                     ),
                     SizedBox(height: 10,),
                     TextFormField(
                       keyboardType: TextInputType.name,

                       decoration: InputDecoration(
                         labelText: 'Имя',
                         //hintText: '(999) 999-99-99',
                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                         //prefix: Text('+7'),
                         prefixIcon: Padding(
                           padding: EdgeInsets.only(left: 8, right: 8),
                           child: const Icon(Icons.person),
                         ),
                         prefixIconConstraints: BoxConstraints(minWidth: 0),
                         fillColor: Colors.white70,
                         filled: true,
                       ),
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return 'Введите номер телефона';
                         }
                         return null;
                       },
                     ),
                   ],
          ),
                   Padding(
                        padding: EdgeInsets.only(
                          bottom:   keyboardHeight,
                        ),
                        child: Align(
                          alignment: AlignmentGeometry.bottomCenter,
                          child:  ElevatedButton(
                            onPressed: (){

                            } ,
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(MediaQuery.of(context).size.width / 2, 54),
                              backgroundColor: const Color(0xFF88b705),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            child: const Text(
                              'Завершить',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          //},
                        )
                    ),



                ],
              ),
            ),
          ),
    ),
    );
  }
}
