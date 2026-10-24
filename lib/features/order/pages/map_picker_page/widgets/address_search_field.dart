

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../data/model/osm_address.dart';
import '../providers/map_picker_controller.dart';

class AddressSearchField extends StatefulWidget {
  const AddressSearchField({super.key});

  @override
  State<AddressSearchField> createState() => _AddressSearchFieldState();
}

class _AddressSearchFieldState extends State<AddressSearchField> {


  @override
  Widget build(BuildContext context) {
    return Consumer<MapPickerController>(
      builder: (context, mapPickerController, child) {
        return  Positioned(
          top: 16,
          right: 16,
          left: 16,
          child: TypeAheadField<OsmAddress>(
            controller: mapPickerController.searchController,
            suggestionsController: mapPickerController.suggestionsController,
            debounceDuration: const Duration(milliseconds: 500),
            // Настройка самой строки ввода (Кастомизируйте дизайн здесь)
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Введите адрес...',
                  prefixIcon: const Icon(
                    Icons.search,
                    //color: Colors.blue,
                  ),
                  suffixIcon: IconButton(
                    icon:Icon( Icons.my_location, color: Colors.blue,),
                     onPressed: () async{
                     await mapPickerController.getCurrentLocation();
                     },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              );
            },
            // Функция коллбэка, которая ищет варианты при вводе текста
            suggestionsCallback: (search) async {
              return await mapPickerController.searchAddress(search);
            },
            // Кастомизация внешнего вида одного элемента в выпадающем списке
            itemBuilder: (context, OsmAddress address) {
              //String fullAddress='${address.city}, ${address.street}, ${address.housenumber}';
              //mapPickerController.osmAddress = address;
              return ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                ),
                title: Text(
                  address.formattedAddress,
                  //mapPickerController.osmAddress.formattedAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
            // Что делать, когда пользователь выбрал адрес из списка
            onSelected: (OsmAddress address) {
              //_address='${address.city}, ${address.street}, ${address.housenumber}';
              mapPickerController.selectAddress(address);
              FocusScope.of(context).unfocus();
            },
            // Текст, если ничего не найдено
            emptyBuilder: (context) => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Ничего не найдено',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
}
