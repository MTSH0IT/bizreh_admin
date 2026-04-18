class Order {
  int? id;
  String? orderNumber;
  double? totalAmount;
  DateTime? createdAt;

  Order({this.id, this.orderNumber, this.totalAmount, this.createdAt});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'] as int?,
    orderNumber: json['order_number'] as String?,
    totalAmount: (json['total_amount'] as num?)?.toDouble(),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_number': orderNumber,
    'total_amount': totalAmount,
    'created_at': createdAt?.toIso8601String(),
  };
}
