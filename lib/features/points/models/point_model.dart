class PointModel {
  int? id;
  String? title;
  String? arTitle;
  int? brandId;
  int? packagingId;
  int? pointsPerUnit;
  int? minQuantity;
  DateTime? startDate;
  DateTime? endDate;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? brandTitle;
  String? brandArTitle;
  String? packagingTitle;
  String? packagingArTitle;

  PointModel({
    this.id,
    this.title,
    this.arTitle,
    this.brandId,
    this.packagingId,
    this.pointsPerUnit,
    this.minQuantity,
    this.startDate,
    this.endDate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.brandTitle,
    this.brandArTitle,
    this.packagingTitle,
    this.packagingArTitle,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) => PointModel(
    id: json['id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    brandId: json['brand_id'] as int?,
    packagingId: json['packaging_id'] as int?,
    pointsPerUnit: json['points_per_unit'] as int?,
    minQuantity: json['min_quantity'] as int?,
    startDate: json['start_date'] == null
        ? null
        : DateTime.parse(json['start_date'] as String),
    endDate: json['end_date'] == null
        ? null
        : DateTime.parse(json['end_date'] as String),
    isActive: json['is_active'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    brandTitle: json['brand_title'] as String?,
    brandArTitle: json['brand_ar_title'] as String?,
    packagingTitle: json['packaging_title'] as String?,
    packagingArTitle: json['packaging_ar_title'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'brand_id': brandId,
    'packaging_id': packagingId,
    'points_per_unit': pointsPerUnit,
    'min_quantity': minQuantity,
    'start_date': startDate?.toIso8601String(),
    'end_date': endDate?.toIso8601String(),
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'brand_title': brandTitle,
    'brand_ar_title': brandArTitle,
    'packaging_title': packagingTitle,
    'packaging_ar_title': packagingArTitle,
  };
}
