// widgets/address_search_field.dart
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
  const AddressField({super.key, /*required this.formKey,*/ required this.fieldKey});

  //final GlobalKey<FormState> formKey;
  final GlobalKey<FormFieldState<String>> fieldKey;

  @override
  State<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  late TextEditingController addressController;
  //final _addressFieldKey = GlobalKey<FormFieldState>();
  late FocusNode _addressFocusNode;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
    _addressFocusNode=FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          //key: _addressFieldKey,
          key: widget.fieldKey,
          focusNode:_addressFocusNode,
          validator: (value){
            if (value == null || value.isEmpty) {
              return 'Заполните поле';
            }
            return null;
          },
          controller: addressController,
          //initialValue: state.address,
          readOnly: true,

          decoration: InputDecoration(
            hintText: 'Улица, дом, квартира',
            helperText: ' ',
            errorMaxLines: 1,
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
      //закладка, проверить прежде чем разфокус делать
      //_addressFieldKey.currentState?.validate();
      //FocusScope.of(context).unfocus();
      _addressFocusNode.unfocus();
      widget.fieldKey.currentState?.validate();

    }else{
      _addressFocusNode.unfocus();
    }
  }
}
