// screens/map_picker_page.dart
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:osm_location_picker/osm_location_picker.dart';
import 'package:planet_sushi_client_app/features/order/pages/map_picker_page/providers/map_picker_controller.dart';
import 'package:planet_sushi_client_app/features/order/pages/map_picker_page/widgets/address_search_field.dart';
import 'package:planet_sushi_client_app/features/order/pages/map_picker_page/widgets/confirm_address_panel.dart';
import 'package:planet_sushi_client_app/features/order/pages/map_picker_page/widgets/custom_map.dart';
import 'package:planet_sushi_client_app/features/order/pages/map_picker_page/widgets/permission_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../injection_container.dart' as di;

@RoutePage()
class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  late final MapPickerController
  mapPickerController; // = di.sl<MapPickerController>();
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    mapPickerController = di.sl<MapPickerController>();
    // запускаем только после первого кадра, когда карта уже смонтирована
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) mapPickerController.checkLocationPermission();
    });
    _listener = AppLifecycleListener(
      onResume: () async {
        print('resume is ');
        if (mapPickerController.isDialogOpened == true) {
          if (mounted) await mapPickerController.checkLocationPermission();
        }
        mapPickerController.isDialogOpened = false;
      },
    );

    mapPickerController.onShowDialog = () {
      showDialog(
        context: context,
        builder: (context) => ChangeNotifierProvider.value(
          value: mapPickerController,
          child: const PermissionDialog(
            message:
                '"Включите разрешение \"Местоположение\" в настройках приложения."',
          ),
        ),
      );
    };
  }

  @override
  void dispose() {
    //mapPickerController.dispose();
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => mapPickerController, //..getCurrentLocation(context),
      child: const Stack(
        children: [CustomMap(), AddressSearchField(), ConfirmAddressPanel()],
      ),
    );
  }
}

//пример для Nominatim-геокодера
// Модель для хранения данных об адресе
/*class OsmAddress {
  final String displayName;
  final double lat;
  final double lon;

  OsmAddress({required this.displayName, required this.lat, required this.lon});

  factory OsmAddress.fromJson(Map<String, dynamic> json) {
    return OsmAddress(
      displayName: json['display_name'] ?? '',
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
    );
  }
}*/
// 'User-Agent': 'FlutterApp/1.0'
//  'User-Agent': 'MyCustomFlutterApp/1.0 (com.prostreet1212.planetSushiClientApp)',
// Используем Nominatim (OpenStreetMap) — без API-ключа
/*final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json'
        '&lat=${point.latitude}&lon=${point.longitude}&accept-language=ru',
      );*/

/*final data = jsonDecode(res.body);
        String city= data['address']['town'] ?? '';
        String road = data['address']['road'] ?? '';
        String house_number = data['address']['house_number'] ?? '';*/
