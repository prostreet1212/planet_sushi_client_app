// widgets/address_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../presentation/cubits/chekout_cubit/chekout_cubit.dart';
import '../../../map_picker_page/map_picker_page.dart';
import '../checkout_form.dart';


class MapPickResult {
  final String address;
  final double latitude;
  final double longitude;

  MapPickResult(this.address, this.latitude, this.longitude);
}

class AddressField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: state.address,
          decoration: InputDecoration(
            hintText: 'Улица, дом, квартира',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.location_on_outlined),
            suffixIcon: IconButton(
              icon: const Icon(Icons.map),
              tooltip: 'Выбрать на карте',
              onPressed: () => _openMap(context),
            ),
          ),
          onChanged: context.read<CheckoutCubit>().setAddress,
        ),
        if (state.latitude != null && state.longitude != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Координаты: ${state.latitude!.toStringAsFixed(5)}, '
                  '${state.longitude!.toStringAsFixed(5)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Future<void> _openMap(BuildContext context) async {
    final result = await Navigator.push<MapPickResult>(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerPage()),
    );
    if (result != null && context.mounted) {
      final cubit = context.read<CheckoutCubit>();
      cubit.setAddress(result.address);
      cubit.setCoordinates(result.latitude, result.longitude);
    }
  }
}