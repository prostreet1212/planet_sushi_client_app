// cubits/checkout_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/model/order_model.dart';
import 'checkout_state.dart';


class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutState());

  void setName(String v) => emit(state.copyWith(name: v));
  void setPhone(String v) => emit(state.copyWith(phone: v));
  void setDeliveryType(DeliveryType v) => emit(state.copyWith(deliveryType: v));
  void setAddress(String v) => emit(state.copyWith(address: v));
  void setCoordinates(double lat, double lng) =>
      emit(state.copyWith(latitude: lat, longitude: lng));
  void setCookingTime(CookingTimeType v) => emit(state.copyWith(
    cookingTimeType: v,
    clearScheduled: v == CookingTimeType.asap,
  ));
  void setScheduledTime(DateTime v) =>
      emit(state.copyWith(scheduledTime: v, cookingTimeType: CookingTimeType.scheduled));
  void setComment(String v) => emit(state.copyWith(comment: v));
  void setPayment(PaymentType v) => emit(state.copyWith(paymentType: v));

  Future<bool> submitOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalPrice,
  }) async {
    emit(state.copyWith(isSubmitting: true, error: null, success: false));

    if (state.name.trim().isEmpty || state.phone.trim().isEmpty) {
      emit(state.copyWith(isSubmitting: false, error: 'Укажите имя и телефон'));
      return false;
    }
    if (state.deliveryType == DeliveryType.delivery &&
        state.address.trim().isEmpty) {
      emit(state.copyWith(isSubmitting: false, error: 'Укажите адрес доставки'));
      return false;
    }
    if (state.cookingTimeType == CookingTimeType.scheduled &&
        state.scheduledTime == null) {
      emit(state.copyWith(isSubmitting: false, error: 'Выберите время приготовления'));
      return false;
    }

    try {
      final order = OrderModel(
        userId: userId,
        customerName: state.name.trim(),
        customerPhone: state.phone.trim(),
        deliveryType: state.deliveryType,
        address: state.deliveryType == DeliveryType.delivery ? state.address : null,
        latitude: state.latitude,
        longitude: state.longitude,
        cookingTimeType: state.cookingTimeType,
        scheduledTime: state.scheduledTime,
        comment: state.comment.trim().isEmpty ? null : state.comment.trim(),
        paymentType: state.paymentType,
        totalPrice: totalPrice,
        items: items,
      );

      await Supabase.instance.client.from('orders').insert(order.toJson());

      emit(state.copyWith(isSubmitting: false, success: true));
      return true;
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: 'Ошибка: $e'));
      return false;
    }
  }
}