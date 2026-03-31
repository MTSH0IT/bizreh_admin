import 'order_item.dart';

class OrderDetails {
  int? orderId;
  String? orderNumber;
  int? totalAmount;
  String? status;
  DateTime? createdAt;
  OrderItem? orderItem;

  OrderDetails({
    this.orderId,
    this.orderNumber,
    this.totalAmount,
    this.status,
    this.createdAt,
    this.orderItem,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
    orderId: json['order_id'] as int?,
    orderNumber: json['order_number'] as String?,
    totalAmount: json['total_amount'] as int?,
    status: json['status'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    orderItem: json['order_item'] == null
        ? null
        : OrderItem.fromJson(json['order_item'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'order_number': orderNumber,
    'total_amount': totalAmount,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'order_item': orderItem?.toJson(),
  };
}
