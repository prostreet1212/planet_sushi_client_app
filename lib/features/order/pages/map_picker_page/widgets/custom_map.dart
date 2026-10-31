import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:planet_sushi_client_app/features/order/pages/map_picker_page/providers/map_picker_controller.dart';
import 'package:provider/provider.dart';

class CustomMap extends StatelessWidget {
  const CustomMap({super.key});
  //final MapPickerController mapPickerController;

  @override
  Widget build(BuildContext context) {
    return Selector<MapPickerController, ({LatLng selected, String formattedAddress})>(
      selector: (_, c) =>
          (selected: c.selected, formattedAddress: c.osmAddress.formattedAddress),
     /* shouldRebuild: (selected,formattedAddress){
        return true;
      },*/
      builder: (context, data, child) {
        return FlutterMap(
          mapController: context.read<MapPickerController>().mapController,
          options: MapOptions(
            initialCenter: data.selected,
            initialZoom: 15,
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            onTap: (_, point) {
              context.read<MapPickerController>().selectPoint(point);
            },
          ),
          children: [
            //MapTileLayer(mapType: MapTileType.osm,languageCode: 'ru',countryCode: 'RU',apiKey: 'cb1_4wr3_1_632b7583c12baabebae1122d',keepBuffer: 10,),
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              //urlTemplate: 'https://tiles.api-maps.yandex.ru/v1/tiles/?projection=web_mercator&x={x}&y={y}&z={z}&lang=ru_RU&l=map&apikey=f5ea70f9-a18d-4c31-b2b9-6f7c157e5b10',
              userAgentPackageName: 'com.prostreet1212.planetSushiClientApp',
            ),
           data.formattedAddress == ''
                ? const SizedBox()
                : MarkerLayer(
                    markers: [
                      Marker(
                        point: data.selected,
                        width: 40,
                        height: 40,
                        alignment: const Alignment(0.1, -0.4),
                        child:Image.asset(
                          'assets/images/pin.png', // Путь к вашему изображению
                          //fit: BoxFit.contain,
                        ),
                        /* const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),*/
                      ),
                    /*  Marker(
                        point: data.selected,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),*/
                    ],
                  ),
          ],
        );
      },
    );
  }
}
