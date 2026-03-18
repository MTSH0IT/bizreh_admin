import 'packaging_option.dart';

class Option {
  int? id;
  int? productId;
  String? optionName;
  String? arOptionName;
  String? mainImage;
  int? stockQuantity;
  DateTime? createdAt;
  List<PackagingOption>? packagingOptions;

  Option({
    this.id,
    this.productId,
    this.optionName,
    this.arOptionName,
    this.mainImage,
    this.stockQuantity,
    this.createdAt,
    this.packagingOptions,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json['id'] as int?,
    productId: json['product_id'] as int?,
    optionName: json['option_name'] as String?,
    arOptionName: json['ar_option_name'] as String?,
    mainImage: json['main_image'] as String?,
    stockQuantity: json['stock_quantity'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    packagingOptions: (json['packaging_options'] as List<dynamic>?)
        ?.map((e) => PackagingOption.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'option_name': optionName,
    'ar_option_name': arOptionName,
    'main_image': mainImage,
    'stock_quantity': stockQuantity,
    'created_at': createdAt?.toIso8601String(),
    'packaging_options': packagingOptions?.map((e) => e.toJson()).toList(),
  };
}
