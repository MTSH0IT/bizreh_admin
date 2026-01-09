import 'color_family.dart';

class Packaging {
  int? id;
  int? packagingTypeId;
  int? pricePerUnit;
  int? stockQuantity;
  String? packagingTitle;
  String? arPackagingTitle;
  List<ColorFamily>? colorFamilies;

  Packaging({
    this.id,
    this.packagingTypeId,
    this.pricePerUnit,
    this.stockQuantity,
    this.packagingTitle,
    this.arPackagingTitle,
    this.colorFamilies,
  });

  factory Packaging.fromJson(Map<String, dynamic> json) => Packaging(
    id: json['id'] as int?,
    packagingTypeId: json['packaging_type_id'] as int?,
    pricePerUnit: json['price_per_unit'] as int?,
    stockQuantity: json['stock_quantity'] as int?,
    packagingTitle: json['packaging_title'] as String?,
    arPackagingTitle: json['ar_packaging_title'] as String?,
    colorFamilies: (json['color_families'] as List<dynamic>?)
        ?.map((e) => ColorFamily.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'packaging_type_id': packagingTypeId,
    'price_per_unit': pricePerUnit,
    'stock_quantity': stockQuantity,
    'packaging_title': packagingTitle,
    'ar_packaging_title': arPackagingTitle,
    'color_families': colorFamilies?.map((e) => e.toJson()).toList(),
  };
}
