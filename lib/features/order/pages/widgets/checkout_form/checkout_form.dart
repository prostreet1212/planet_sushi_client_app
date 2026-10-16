// widgets/checkout_form.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:planet_sushi_client_app/features/order/pages/widgets/checkout_form/widgets/address_field.dart';
import 'package:planet_sushi_client_app/features/order/pages/widgets/checkout_form/widgets/label_field.dart';
import 'package:planet_sushi_client_app/features/order/pages/widgets/checkout_form/widgets/section_title.dart';
import 'package:planet_sushi_client_app/features/order/pages/widgets/checkout_form/widgets/time_picker_field.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/cubits/profile_cubit/profile_state.dart';

import '../../../data/model/order_model.dart';
import '../../../presentation/cubits/chekout_cubit/checkout_state.dart';
import '../../../presentation/cubits/chekout_cubit/chekout_cubit.dart';

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
              const SectionTitle('Контакты'),
              Row(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  LabeledField(
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
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                          maxWidth: 43,
                          maxHeight: 43,
                        ),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.edit),
                          tooltip: 'Выбрать на карте',
                          onPressed: null,
                        ),
                      ),
                      onChanged: context.read<CheckoutCubit>().setName,
                    ),
                  ),
                  const SizedBox(width: 12),
                  LabeledField(
                    label: 'Телефон',
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      enabled: false,
                      //readOnly: true,
                      style: TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        prefix: const Text(
                          '+',
                          style: TextStyle(color: Colors.black),
                        ),

                        isDense: true,
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                          ), // Ваша кастомная граница
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        hintText: '+7 (___) ___-__-__',
                        border: OutlineInputBorder(),
                      ),
                      //onChanged: context.read<CheckoutCubit>().setPhone,
                      onChanged: null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const SectionTitle('Способ получения'),
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
                AddressField(),
              ],

              const SizedBox(height: 20),
              const SectionTitle('Когда приготовить'),
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
                TimePickerField(),
              ],

              const SizedBox(height: 20),
              const SectionTitle('Комментарий'),
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
              const SectionTitle('Способ оплаты'),
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
