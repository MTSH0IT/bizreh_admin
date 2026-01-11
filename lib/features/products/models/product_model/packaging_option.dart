import 'color.dart';

class PackagingOption {
  int? id;
  int? packagingId;
  int? pricePerUnit;
  int? stockQuantity;
  String? packagingTitle;
  String? arPackagingTitle;
  Color? color;

  PackagingOption({
    this.id,
    this.packagingId,
    this.pricePerUnit,
    this.stockQuantity,
    this.packagingTitle,
    this.arPackagingTitle,
    this.color,
  });

  @override
  String toString() {
    return 'PackagingOption(id: $id, packagingId: $packagingId, pricePerUnit: $pricePerUnit, stockQuantity: $stockQuantity, packagingTitle: $packagingTitle, arPackagingTitle: $arPackagingTitle, color: $color)';
  }

  factory PackagingOption.fromJson(Map<String, dynamic> json) {
    return PackagingOption(
      id: json['id'] as int?,
      packagingId: json['packaging_id'] as int?,
      pricePerUnit: json['price_per_unit'] as int?,
      stockQuantity: json['stock_quantity'] as int?,
      packagingTitle: json['packaging_title'] as String?,
      arPackagingTitle: json['ar_packaging_title'] as String?,
      color: json['color'] == null
          ? null
          : Color.fromJson(json['color'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'packaging_id': packagingId,
    'price_per_unit': pricePerUnit,
    'stock_quantity': stockQuantity,
    'packaging_title': packagingTitle,
    'ar_packaging_title': arPackagingTitle,
    'color': color?.toJson(),
  };
}
