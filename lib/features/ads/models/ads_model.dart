class AdsModel {
  int? id;
  int? productId;
  String? title;
  String? arTitle;
  String? description;
  String? arDescription;
  String? image;
  int? isActive;
  DateTime? createdAt;

  AdsModel({
    this.id,
    this.productId,
    this.title,
    this.arTitle,
    this.description,
    this.arDescription,
    this.image,
    this.isActive,
    this.createdAt,
  });

  @override
  String toString() {
    return 'AdsModel(id: $id, productId: $productId, title: $title, arTitle: $arTitle, description: $description, arDescription: $arDescription, image: $image, isActive: $isActive, createdAt: $createdAt)';
  }

  factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
    id: json['id'] as int?,
    productId: json['product_id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    description: json['description'] as String?,
    arDescription: json['ar_description'] as String?,
    image: json['image'] as String?,
    isActive: json['is_active'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'title': title,
    'ar_title': arTitle,
    'description': description,
    'ar_description': arDescription,
    'image': image,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
  };
}
