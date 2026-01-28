class GiftsModel {
  int? id;
  int? points;
  String? title;
  String? arTitle;
  String? image;
  int? isActive;
  DateTime? createdAt;
  int? totalRedemptions;
  dynamic availableQuantity;
  bool? isAvailable;

  GiftsModel({
    this.id,
    this.points,
    this.title,
    this.arTitle,
    this.image,
    this.isActive,
    this.createdAt,
    this.totalRedemptions,
    this.availableQuantity,
    this.isAvailable,
  });

  @override
  String toString() {
    return 'GiftsModel(id: $id, points: $points, title: $title, arTitle: $arTitle, image: $image, isActive: $isActive, createdAt: $createdAt, totalRedemptions: $totalRedemptions, availableQuantity: $availableQuantity, isAvailable: $isAvailable)';
  }

  factory GiftsModel.fromJson(Map<String, dynamic> json) => GiftsModel(
    id: json['id'] as int?,
    points: json['points'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    image: json['image'] as String?,
    isActive: json['is_active'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    totalRedemptions: json['total_redemptions'] as int?,
    availableQuantity: json['available_quantity'] as dynamic,
    isAvailable: json['is_available'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'points': points,
    'title': title,
    'ar_title': arTitle,
    'image': image,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'total_redemptions': totalRedemptions,
    'available_quantity': availableQuantity,
    'is_available': isAvailable,
  };
}
