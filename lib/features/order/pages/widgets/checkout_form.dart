// widgets/checkout_form.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/cubits/profile_cubit/profile_state.dart';

import '../../../profile/presentation/cubits/profile_cubit/profile_cubit.dart';
import '../../data/model/order_model.dart';
import '../../presentation/cubits/chekout_cubit/checkout_state.dart';
import '../../presentation/cubits/chekout_cubit/chekout_cubit.dart';

class CheckoutForm extends StatefulWidget {
  const CheckoutForm({super.key});

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: context.read<CheckoutCubit>().state.name,
    );
    phoneController = TextEditingController(
      text: context.read<CheckoutCubit>().state.phone,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  /// Синхронизация cubit -> контроллеры.
  void syncControllers(CheckoutState s) {
    _setIfChanged(nameController, s.name);
    _setIfChanged(phoneController, s.phone);
  }

  void _setIfChanged(TextEditingController c, String value) {
    if (c.text == value) return; // не трогаем, пока пользователь печатает
    c.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listenWhen: (prev, next) {
        return prev.name != next.name || prev.phone != next.phone;
      },
      listener: (context, checkoutFormState) {
        syncControllers(checkoutFormState);
      },
      builder: (context, checkoutFormState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SectionTitle('Контакты'),
              Row(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  _LabeledField(
                    label: 'Имя',
                    child: TextFormField(
                      controller: nameController,

                      decoration: InputDecoration(
                        hintText: 'Ваше имя',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        //isCollapsed: true,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Выбрать на карте',
                          onPressed: null,
                        ),
                      ),
                      onChanged: context.read<CheckoutCubit>().setName,
                    ),
                  ),

                  const SizedBox(width: 12),
                  _LabeledField(
                    label: 'Телефон',
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      //закладка
                      //enabled: false,
                      readOnly: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        hintText: '+7 (___) ___-__-__',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: context.read<CheckoutCubit>().setPhone,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const _SectionTitle('Способ получения'),
              SegmentedButton<DeliveryType>(
                segments: const [
                  ButtonSegment(
                    value: DeliveryType.delivery,
                    label: Text('Доставка'),
                    icon: Icon(Icons.delivery_dining),
                  ),
                  ButtonSegment(
                    value: DeliveryType.pickup,
                    label: Text('Самовывоз'),
                    icon: Icon(Icons.store),
                  ),
                ],
                selected: {checkoutFormState.deliveryType},
                onSelectionChanged: (s) =>
                    context.read<CheckoutCubit>().setDeliveryType(s.first),
              ),

              if (checkoutFormState.deliveryType == DeliveryType.delivery) ...[
                const SizedBox(height: 12),
                _AddressField(),
              ],

              const SizedBox(height: 20),
              const _SectionTitle('Когда приготовить'),
              SegmentedButton<CookingTimeType>(
                segments: const [
                  ButtonSegment(
                    value: CookingTimeType.asap,
                    label: Text('По готовности'),
                    icon: Icon(Icons.flash_on),
                  ),
                  ButtonSegment(
                    value: CookingTimeType.scheduled,
                    label: Text('Ко времени'),
                    icon: Icon(Icons.schedule),
                  ),
                ],
                selected: {checkoutFormState.cookingTimeType},
                onSelectionChanged: (s) =>
                    context.read<CheckoutCubit>().setCookingTime(s.first),
              ),
              if (checkoutFormState.cookingTimeType ==
                  CookingTimeType.scheduled) ...[
                const SizedBox(height: 12),
                _TimePickerField(),
              ],

              const SizedBox(height: 20),
              const _SectionTitle('Комментарий'),
              TextFormField(
                initialValue: checkoutFormState.comment,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Пожелания к заказу...',
                  border: OutlineInputBorder(),
                ),
                onChanged: context.read<CheckoutCubit>().setComment,
              ),

              const SizedBox(height: 20),
              const _SectionTitle('Способ оплаты'),
              RadioListTile<PaymentType>(
                value: PaymentType.onReceipt,
                groupValue: checkoutFormState.paymentType,
                onChanged: (v) => context.read<CheckoutCubit>().setPayment(v!),
                title: const Text('При получении'),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              RadioListTile<PaymentType>(
                value: PaymentType.cardNow,
                groupValue: checkoutFormState.paymentType,
                onChanged: (v) => context.read<CheckoutCubit>().setPayment(v!),
                title: const Text('Картой сейчас'),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),

              if (checkoutFormState.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    checkoutFormState.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

// widgets/address_field.dart
class _AddressField extends StatelessWidget {
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
      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
    );
    if (result != null && context.mounted) {
      final cubit = context.read<CheckoutCubit>();
      cubit.setAddress(result.address);
      cubit.setCoordinates(result.latitude, result.longitude);
    }
  }
}

class MapPickResult {
  final String address;
  final double latitude;
  final double longitude;

  MapPickResult(this.address, this.latitude, this.longitude);
}

// screens/map_picker_screen.dart

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();
  LatLng _selected = const LatLng(55.751244, 37.618423); // Москва
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
        _address = data['display_name'] ?? '';
      }
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор адреса')),
      body: Stack(
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
                userAgentPackageName: 'com.example.app',
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
                            : () => Navigator.pop(
                                context,
                                MapPickResult(
                                  _address,
                                  _selected.latitude,
                                  _selected.longitude,
                                ),
                              ),
                        child: const Text('Подтвердить адрес'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimePickerField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutCubit>().state;
    final label = state.scheduledTime == null
        ? 'Выбрать время'
        : DateFormat('dd.MM.yyyy HH:mm').format(state.scheduledTime!);

    return OutlinedButton.icon(
      icon: const Icon(Icons.access_time),
      label: Text(label),
      onPressed: () async {
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now,
          lastDate: now.add(const Duration(days: 30)),
        );
        if (date == null || !context.mounted) return;
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time == null) return;
        final dt = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        context.read<CheckoutCubit>().setScheduledTime(dt);
      },
    );
  }
}
