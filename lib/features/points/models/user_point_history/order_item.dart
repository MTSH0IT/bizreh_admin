import 'product.dart';

class OrderItem {
  int? id;
  int? quantity;
  int? unitPrice;
  int? totalPrice;
  Product? product;

  OrderItem({
    this.id,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json['id'] as int?,
    quantity: json['quantity'] as int?,
    unitPrice: json['unit_price'] as int?,
    totalPrice: json['total_price'] as int?,
    product: json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'quantity': quantity,
    'unit_price': unitPrice,
    'total_price': totalPrice,
    'product': product?.toJson(),
  };
}
