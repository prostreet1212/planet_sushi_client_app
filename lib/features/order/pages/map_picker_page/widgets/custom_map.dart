import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:planet_sushi_client_app/features/order/pages/map_picker_page/providers/map_picker_controller.dart';
import 'package:provider/provider.dart';

class CustomMap extends StatelessWidget {
  const CustomMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapPickerController>(

      builder: (context, mapPickerController,child) {
        return FlutterMap(
          mapController: mapPickerController.mapController,
          options: MapOptions(
            initialCenter: mapPickerController.selected,
            initialZoom: 15,
            onTap: (_, point) {
              mapPickerController.selectPoint(point);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.prostreet1212.planetSushiClientApp',
            ),
            mapPickerController.osmAddress.formattedAddress=='' ? const SizedBox() : MarkerLayer(
              markers: [
                Marker(
                  point: mapPickerController.selected,
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
        );
      },
    );
  }
}
