import 'color.dart';
import 'packaging.dart';
import 'product.dart';
import 'product_option.dart';

class ProductsSku {
  int? id;
  int? productOptionId;
  int? packagingId;
  int? colorId;
  String? optionSku;
  double? pricePerUnit;
  int? stockQuantity;
  DateTime? createdAt;
  ProductOption? productOption;
  Product? product;
  Packaging? packaging;
  Color? color;

  ProductsSku({
    this.id,
    this.productOptionId,
    this.packagingId,
    this.colorId,
    this.optionSku,
    this.pricePerUnit,
    this.stockQuantity,
    this.createdAt,
    this.productOption,
    this.product,
    this.packaging,
    this.color,
  });

  factory ProductsSku.fromJson(Map<String, dynamic> json) => ProductsSku(
    id: json['id'] as int?,
    productOptionId: json['product_option_id'] as int?,
    packagingId: json['packaging_id'] as int?,
    colorId: json['color_id'] as int?,
    optionSku: json['option_sku'] as String?,
    pricePerUnit: (json['price_per_unit'] as num?)?.toDouble(),
    stockQuantity: json['stock_quantity'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    productOption: json['product_option'] == null
        ? null
        : ProductOption.fromJson(
            json['product_option'] as Map<String, dynamic>,
          ),
    product: json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
    packaging: json['packaging'] == null
        ? null
        : Packaging.fromJson(json['packaging'] as Map<String, dynamic>),
    color: json['color'] == null
        ? null
        : Color.fromJson(json['color'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_option_id': productOptionId,
    'packaging_id': packagingId,
    'color_id': colorId,
    'option_sku': optionSku,
    'price_per_unit': pricePerUnit,
    'stock_quantity': stockQuantity,
    'created_at': createdAt?.toIso8601String(),
    'product_option': productOption?.toJson(),
    'product': product?.toJson(),
    'packaging': packaging?.toJson(),
    'color': color?.toJson(),
  };
}
