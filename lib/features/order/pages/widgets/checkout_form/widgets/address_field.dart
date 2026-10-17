// widgets/address_field.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/core/routers/app_router.dart';

import '../../../../presentation/cubits/chekout_cubit/chekout_cubit.dart';
import '../../../map_picker_page/map_picker_page.dart';
import '../checkout_form.dart';

class MapPickResult {
  final String address;
  final double latitude;
  final double longitude;

  MapPickResult(this.address, this.latitude, this.longitude);
}

class AddressField extends StatefulWidget {
  @override
  State<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: addressController,
          //initialValue: state.address,
          readOnly: true,
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
          //onChanged: context.read<CheckoutCubit>().setAddress,
          onTap: () => _openMap(context),
        ),

      ],
    );
  }

  Future<void> _openMap(BuildContext context) async {
   /* final result = await Navigator.push<MapPickResult>(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerPage()),
    );*/
    final result=await context.router.push<MapPickResult>(MapPickerRoute());
    if (result != null && context.mounted) {
      final cubit = context.read<CheckoutCubit>();
      cubit.setAddress(result.address);
      cubit.setCoordinates(result.latitude, result.longitude);
      setState(() {
        addressController.text = result.address;
      });

    }
  }
}
