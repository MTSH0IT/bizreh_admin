import 'order.dart';
import 'payment.dart';
import 'summary.dart';

class UserPaymentAndOrderModel {
  String? userId;
  Summary? summary;
  List<Order>? orders;
  List<Payment>? payments;

  UserPaymentAndOrderModel({
    this.userId,
    this.summary,
    this.orders,
    this.payments,
  });

  factory UserPaymentAndOrderModel.fromJson(Map<String, dynamic> json) {
    return UserPaymentAndOrderModel(
      userId: json['user_id'] as String?,
      summary: json['summary'] == null
          ? null
          : Summary.fromJson(json['summary'] as Map<String, dynamic>),
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>?)
          ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'summary': summary?.toJson(),
    'orders': orders?.map((e) => e.toJson()).toList(),
    'payments': payments?.map((e) => e.toJson()).toList(),
  };
}
