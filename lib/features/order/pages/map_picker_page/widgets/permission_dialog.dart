import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planet_sushi_client_app/features/order/pages/map_picker_page/providers/map_picker_controller.dart';
import 'package:provider/provider.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Consumer<MapPickerController>(

      builder: (context, mapPickerController,child) {
        return AlertDialog(
          title: const Text("Разрешение отклонено"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () async {
                mapPickerController
                    .isDialogOpened = true;
                Navigator.pop(context);
                await openAppSettings().then((data) {}).whenComplete(() {});

              },
              child: const Text(
                "Открыть настройки",
                style: TextStyle(color: Color.fromARGB(255, 42, 150, 131)),
              ),
            ),
          ],
        );
      },
    );
  }
}