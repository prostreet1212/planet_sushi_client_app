import '../../../data/model/order_model.dart';

class CheckoutState {
  final String name;
  final String phone;
  final DeliveryType deliveryType;
  final String address;
  final double? latitude;
  final double? longitude;
  final CookingTimeType cookingTimeType;
  final DateTime? scheduledTime;
  final String comment;
  final PaymentType paymentType;
  final bool isSubmitting;
  final String? error;
  final bool success;

  CheckoutState({
    this.name = '',
    this.phone = '',
    this.deliveryType = DeliveryType.delivery,
    this.address = '',
    this.latitude,
    this.longitude,
    this.cookingTimeType = CookingTimeType.asap,
    this.scheduledTime,
    this.comment = '',
    this.paymentType = PaymentType.onReceipt,
    this.isSubmitting = false,
    this.error,
    this.success = false,
  });

  CheckoutState copyWith({
    String? name,
    String? phone,
    DeliveryType? deliveryType,
    String? address,
    double? latitude,
    double? longitude,
    CookingTimeType? cookingTimeType,
    DateTime? scheduledTime,
    String? comment,
    PaymentType? paymentType,
    bool? isSubmitting,
    String? error,
    bool? success,
    bool clearScheduled = false,
  }) =>
      CheckoutState(
        name: name ?? this.name,
        phone: phone ?? this.phone,
        deliveryType: deliveryType ?? this.deliveryType,
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        cookingTimeType: cookingTimeType ?? this.cookingTimeType,
        scheduledTime: clearScheduled ? null : (scheduledTime ?? this.scheduledTime),
        comment: comment ?? this.comment,
        paymentType: paymentType ?? this.paymentType,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        error: error,
        success: success ?? this.success,
      );
}