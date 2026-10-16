// models/order_model.dart
import 'package:supabase_flutter/supabase_flutter.dart';

enum DeliveryType { delivery, pickup }
enum CookingTimeType { asap, scheduled }
enum PaymentType { onReceipt, cardNow }

class OrderModel {
  final String? id;
  final int? orderNumber;
  final String userId;
  final String customerName;
  final String customerPhone;
  final DeliveryType deliveryType;
  final String? address;
  final double? latitude;
  final double? longitude;
  final CookingTimeType cookingTimeType;
  final DateTime? scheduledTime;
  final String? comment;
  final PaymentType paymentType;
  final double totalPrice;
  final List<Map<String, dynamic>> items;
  final DateTime createdAt;

  OrderModel({
    this.id,
     this.orderNumber,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryType,
    this.address,
    this.latitude,
    this.longitude,
    required this.cookingTimeType,
    this.scheduledTime,
    this.comment,
    required this.paymentType,
    required this.totalPrice,
    required this.items,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'user_id': userId,
    'customer_name': customerName,
    'customer_phone': customerPhone,
    'delivery_type': deliveryType.name,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'cooking_time_type': cookingTimeType.name,
    'scheduled_time': scheduledTime?.toIso8601String(),
    'comment': comment,
    'payment_type': paymentType.name,
    'total_price': totalPrice,
    'items': items,
    'created_at': createdAt.toIso8601String(),
  };
}