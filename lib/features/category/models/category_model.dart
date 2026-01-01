class CategoryModel {
  int? id;
  String? title;
  String? arTitle;
  String? image;
  int? superCategoryId;
  int? position;
  DateTime? createdAt;

  CategoryModel({
    this.id,
    this.title,
    this.arTitle,
    this.image,
    this.superCategoryId,
    this.position,
    this.createdAt,
  });

  @override
  String toString() {
    return 'CategoryModel(id: $id, title: $title, arTitle: $arTitle, image: $image, superCategoryId: $superCategoryId, position: $position, createdAt: $createdAt)';
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    image: json['image'] as String?,
    superCategoryId: json['super_category_id'] as int?,
    position: json['position'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'image': image,
    'super_category_id': superCategoryId,
    'position': position,
    'created_at': createdAt?.toIso8601String(),
  };
}
