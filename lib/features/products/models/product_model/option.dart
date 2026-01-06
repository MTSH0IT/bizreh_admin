import 'packaging.dart';

class Option {
  int? id;
  int? productId;
  String? optionName;
  String? arOptionName;
  String? optionSku;
  int? stockQuantity;
  DateTime? createdAt;
  List<Packaging>? packaging;

  Option({
    this.id,
    this.productId,
    this.optionName,
    this.arOptionName,
    this.optionSku,
    this.stockQuantity,
    this.createdAt,
    this.packaging,
  });

  @override
  String toString() {
    return 'Option(id: $id, productId: $productId, optionName: $optionName, arOptionName: $arOptionName, optionSku: $optionSku, stockQuantity: $stockQuantity, createdAt: $createdAt, packaging: $packaging)';
  }

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json['id'] as int?,
    productId: json['product_id'] as int?,
    optionName: json['option_name'] as String?,
    arOptionName: json['ar_option_name'] as String?,
    optionSku: json['option_sku'] as String?,
    stockQuantity: json['stock_quantity'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    packaging: (json['packaging'] as List<dynamic>?)
        ?.map((e) => Packaging.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'option_name': optionName,
    'ar_option_name': arOptionName,
    'option_sku': optionSku,
    'stock_quantity': stockQuantity,
    'created_at': createdAt?.toIso8601String(),
    'packaging': packaging?.map((e) => e.toJson()).toList(),
  };
}
