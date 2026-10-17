// screens/map_picker_page.dart
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../widgets/checkout_form/widgets/address_field.dart';

@RoutePage()
class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  final MapController _mapController = MapController();
  LatLng _selected = const LatLng(61.23661, 46.64179); // Москва
  String _address = '';
  bool _loading = false;

  Future<void> _reverseGeocode(LatLng point) async {
    setState(() => _loading = true);
    try {
      // Используем Nominatim (OpenStreetMap) — без API-ключа
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json'
        '&lat=${point.latitude}&lon=${point.longitude}&accept-language=ru',
      );
      final res = await http.get(
        url,
        headers: {'User-Agent': 'FlutterApp/1.0'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
       // _address = data['display_name'] ?? '';
        String road = data['address']['road'] ?? '';
        String house_number = data['address']['house_number'] ?? '';

        _address = 'ул. ${road}, д. ${house_number}';
      }
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _selected,
            initialZoom: 15,
            onTap: (_, point) {
              setState(() => _selected = point);
              _reverseGeocode(point);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.prostreet1212.planetSushiClientApp',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _selected,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
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
                    _loading
                        ? 'Определяем адрес...'
                        : (_address.isEmpty
                              ? 'Коснитесь карты для выбора точки'
                              : _address),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _address.isEmpty
                          ? null
                          : () => context.router.maybePopTop(
                              MapPickResult(
                                _address,
                                _selected.latitude,
                                _selected.longitude,
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
        ),
      ],
    );
  }
}
