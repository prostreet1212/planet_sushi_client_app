

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../widgets/checkout_form/widgets/address_field.dart';
import '../providers/map_picker_controller.dart';

class ConfirmAddressPanel extends StatelessWidget {
  const ConfirmAddressPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapPickerController>(
      builder: (context, mapPickerController, child) {
        return  Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mapPickerController.loading
                        ? 'Определяем адрес...'
                        : mapPickerController.osmAddress.formattedAddress.isEmpty
                        ? 'Коснитесь карты для выбора точки'
                        : mapPickerController.osmAddress.formattedAddress,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: mapPickerController.osmAddress.formattedAddress.isEmpty
                          ? null
                          : () => context.router.maybePopTop(
                        MapPickResult(
                          mapPickerController.osmAddress.formattedAddress,
                          mapPickerController.selected.latitude,
                          mapPickerController.selected.longitude,
                        ),
                      ),
                      /*Navigator.pop(
                          context,
                          MapPickResult(
                            _address,
                            _selected.latitude,
                            _selected.longitude,
                          ),
                        ),*/
                      child: const Text('Подтвердить адрес'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ) ;
  }
}
