import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

//import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
//import 'package:permission_handler/permission_handler.dart'  ;

import '../../../data/model/osm_address.dart';

class MapPickerController extends ChangeNotifier {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  final SuggestionsController<OsmAddress> suggestionsController =
      SuggestionsController<OsmAddress>();

  VoidCallback? onShowDialog;
  bool _isDialogOpened = false;
   PermissionStatus prevStatus=PermissionStatus.denied;

  LatLng _selected = const LatLng(61.23661, 46.64179);
  OsmAddress _osmAddress = OsmAddress(
    name: '',
    city: '',
    street: '',
    housenumber: '',
    country: '',
    countryCode: '',
    postcode: '',
    longitude: 46.64179,
    latitude: 61.23661,
  );

  bool _loading = false;
  int _reverseRequestId = 0;
  bool _disposed = false;

  // ----- геттеры -----
  LatLng get selected => _selected;

  OsmAddress get osmAddress => _osmAddress;

  bool get loading => _loading;

  bool get isDialogOpened => _isDialogOpened;

  // ----- сеттеры -----
  set selected(LatLng value) => _selected = value;

  set osmAddress(OsmAddress value) => _osmAddress = value;

  set isDialogOpened(bool value) => _isDialogOpened = value;

  @override
  void dispose() {
    _disposed = true;
    suggestionsController.dispose();
    searchController.dispose();
    mapController.dispose();
    super.dispose();
  }

  /// Безопасный notifyListeners, чтобы не упасть после dispose
  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  // ----- выбор точки на карте -----
  Future<void> selectPoint(LatLng point) async {
    _selected = point;
    suggestionsController.close();
    suggestionsController.unfocus();
    searchController.clear();
    _safeNotify();
    await _reverseGeocode(point);
  }

  // ----- обратный геокодинг -----
  Future<void> _reverseGeocode(LatLng point) async {
    final int requestId = ++_reverseRequestId;
    _loading = true;
    _safeNotify();

    try {
      final url = Uri.parse('https://photon.komoot.io/reverse').replace(
        queryParameters: {
          'lon': '${point.longitude}',
          'lat': '${point.latitude}',
        },
      );

      final res = await http.get(
        url,
        headers: {
          'User-Agent': 'MyFlutterApp/1.0 (contact: prostreet1212@gmail.com)',
        },
      );

      if (requestId != _reverseRequestId) return;
      if (_disposed) return;

      if (res.statusCode == 200) {
        final Map<String, dynamic> root = json.decode(res.body);
        final data = root['features'] as List;
        if (data.isNotEmpty) {
          _osmAddress = OsmAddress.fromJson(data.first as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('Ошибка reverse geocode: $e');
    }

    if (requestId != _reverseRequestId) return;
    if (_disposed) return;

    _loading = false;
    _safeNotify();
  }

  // ----- поиск адреса -----
  Future<List<OsmAddress>> searchAddress(String query) async {
    if (query.length < 3) return [];

    final url = Uri.parse('https://photon.komoot.io/api/').replace(
      queryParameters: {
        'q': query,
        'limit': '10',
        'bbox': '46.55,61.15,46.75,61.35',
      },
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'MyFlutterApp/1.0 (contact: prostreet1212@gmail.com)',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> root = json.decode(response.body);
        final List<dynamic> data = root['features'] as List<dynamic>;
        return data
            .map((json) => OsmAddress.fromJson(json))
            .where((a) => a.city != '' && a.street != '')
            .toList();
      }
    } catch (e) {
      debugPrint('Ошибка поиска: $e');
    }
    return [];
  }

  // ----- выбор адреса из выпадающего списка -----
  void selectAddress(OsmAddress address) {
    suggestionsController.close();
    suggestionsController.unfocus();
    _osmAddress = address;
    searchController.text = _osmAddress.formattedAddress;
    _selected = LatLng(_osmAddress.latitude, _osmAddress.longitude);
    _safeNotify();

    mapController.move(_selected, mapController.camera.zoom);

    debugPrint('Выбран адрес: ${address.name}');
    debugPrint(
      'Координаты: Широта: ${address.latitude}, Долгота: ${address.longitude}',
    );
  }

  Future<void> checkLocationPermission() async {

    //закладка
    /*PermissionStatus permission = await Permission.location.status;
    if (permission == PermissionStatus.denied) {
      permission = await Permission.location.request();
      if (permission == PermissionStatus.denied) {
        _loading = false;
        _safeNotify();
        return;
      }else if(permission == PermissionStatus.permanentlyDenied){
        bool isShown = await Permission.location.shouldShowRequestRationale;
        if(isShown){
          //show dialog
          if (onShowDialog != null) {
          onShowDialog!();
          return;
        }
        }else{
          return;
        }

        return;
      };
    }else if(permission == PermissionStatus.permanentlyDenied){
      if (onShowDialog != null) {
        onShowDialog!();
        return;
      }
    }*/
    if (_disposed) return;
    _loading = true;
    if (!await Location().isBackgroundPermissionGranted()) {
      var status = await Location().requestPermission();
      if (status == PermissionStatus.granted) {
      } else if (status == PermissionStatus.denied) {
        prevStatus = PermissionStatus.denied;
        _loading = false;
        return;
      } else if (status == PermissionStatus.deniedForever) {
        if (prevStatus == PermissionStatus.denied||_isDialogOpened==true) {
          prevStatus = PermissionStatus.deniedForever;
          _loading = false;
          return;
        } else {
          if (onShowDialog != null) {
            onShowDialog!();
            return;
          }
        }
      }
    }

    //проверка на вкл. гео-сервиса
    // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    bool serviceEnabled = await Location().serviceEnabled();
    if (!serviceEnabled) {
      // Показывает системный диалог Android для включения GPS
      serviceEnabled = await Location().requestService();
      if (!serviceEnabled) {
        _loading = false;
        _safeNotify();
        return; // Пользователь отказался включать
      }
    }

    // Получаем текущие координаты устройства
    /*Position position = await Geolocator.getCurrentPosition();
    _selected = LatLng(position.latitude, position.longitude);*/
    LocationData position = await Location().getLocation();
    _selected = LatLng(position.latitude, position.longitude);
    mapController.move(_selected, mapController.camera.zoom);
    await _reverseGeocode(_selected);
    _safeNotify();
  }
}
