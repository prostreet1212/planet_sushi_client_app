

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/checkout_form/widgets/address_field.dart';
import '../providers/map_picker_controller.dart';

class ConfirmAddressPanel extends StatelessWidget {
  const ConfirmAddressPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MapPickerController,
        ({bool loading, String formattedAddress, String housenumber})>(
      selector: (_, controller) => (
        loading: controller.loading,
        formattedAddress: controller.osmAddress.formattedAddress,
        housenumber: controller.osmAddress.housenumber,
      ),
      builder: (context, data, child) {
        return Positioned(
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
                    data.loading
                        ? 'Определяем адрес...'
                        : data.formattedAddress.isEmpty
                        ? 'Коснитесь карты для выбора точки'
                        : data.formattedAddress,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          data.formattedAddress.isEmpty ||
                              data.housenumber.isEmpty ||
                              data.loading
                              ? null
                              : () => context.router.maybePopTop(
                                MapPickResult(
                                  data.formattedAddress,
                                  context
                                      .read<MapPickerController>()
                                      .selected
                                      .latitude,
                                  context
                                      .read<MapPickerController>()
                                      .selected
                                      .longitude,
                                ),
                              ),
                      child: Text(
                        data.housenumber.isEmpty
                            ? 'Укажите адрес с точностью до дома'
                            : 'Подтвердить адрес',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
