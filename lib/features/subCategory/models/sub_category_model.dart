class SubCategoryModel {
  int? id;
  String? title;
  String? arTitle;
  String? image;
  int? categoryId;
  int? position;
  DateTime? createdAt;

  SubCategoryModel({
    this.id,
    this.title,
    this.arTitle,
    this.image,
    this.categoryId,
    this.position,
    this.createdAt,
  });

  @override
  String toString() {
    return 'SubCategoryModel(id: $id, title: $title, arTitle: $arTitle, image: $image, categoryId: $categoryId, position: $position, createdAt: $createdAt)';
  }

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      arTitle: json['ar_title'] as String?,
      image: json['image'] as String?,
      categoryId: json['category_id'] as int?,
      position: json['position'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'image': image,
    'category_id': categoryId,
    'position': position,
    'created_at': createdAt?.toIso8601String(),
  };
}
