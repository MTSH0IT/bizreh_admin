class Packaging {
  int? id;
  int? packagingTypeId;
  int? pricePerUnit;
  int? stockQuantity;
  String? packagingTitle;
  String? arPackagingTitle;
  List<dynamic>? colorFamilies;

  Packaging({
    this.id,
    this.packagingTypeId,
    this.pricePerUnit,
    this.stockQuantity,
    this.packagingTitle,
    this.arPackagingTitle,
    this.colorFamilies,
  });

  @override
  String toString() {
    return 'Packaging(id: $id, packagingTypeId: $packagingTypeId, pricePerUnit: $pricePerUnit, stockQuantity: $stockQuantity, packagingTitle: $packagingTitle, arPackagingTitle: $arPackagingTitle, colorFamilies: $colorFamilies)';
  }

  factory Packaging.fromJson(Map<String, dynamic> json) => Packaging(
    id: json['id'] as int?,
    packagingTypeId: json['packaging_type_id'] as int?,
    pricePerUnit: json['price_per_unit'] as int?,
    stockQuantity: json['stock_quantity'] as int?,
    packagingTitle: json['packaging_title'] as String?,
    arPackagingTitle: json['ar_packaging_title'] as String?,
    colorFamilies: json['color_families'] as List<dynamic>?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'packaging_type_id': packagingTypeId,
    'price_per_unit': pricePerUnit,
    'stock_quantity': stockQuantity,
    'packaging_title': packagingTitle,
    'ar_packaging_title': arPackagingTitle,
    'color_families': colorFamilies,
  };
}
