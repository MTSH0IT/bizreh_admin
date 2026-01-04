class AllSubCategoryModel {
  int? id;
  String? title;
  String? arTitle;
  String? image;
  int? categoryId;
  int? position;
  DateTime? createdAt;
  String? categoryTitle;
  String? categoryArTitle;
  String? superCategoryTitle;
  String? superCategoryArTitle;

  AllSubCategoryModel({
    this.id,
    this.title,
    this.arTitle,
    this.image,
    this.categoryId,
    this.position,
    this.createdAt,
    this.categoryTitle,
    this.categoryArTitle,
    this.superCategoryTitle,
    this.superCategoryArTitle,
  });

  @override
  String toString() {
    return 'AllSubCategoryModel(id: $id, title: $title, arTitle: $arTitle, image: $image, categoryId: $categoryId, position: $position, createdAt: $createdAt, categoryTitle: $categoryTitle, categoryArTitle: $categoryArTitle, superCategoryTitle: $superCategoryTitle, superCategoryArTitle: $superCategoryArTitle)';
  }

  factory AllSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return AllSubCategoryModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      arTitle: json['ar_title'] as String?,
      image: json['image'] as String?,
      categoryId: json['category_id'] as int?,
      position: json['position'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      categoryTitle: json['category_title'] as String?,
      categoryArTitle: json['category_ar_title'] as String?,
      superCategoryTitle: json['super_category_title'] as String?,
      superCategoryArTitle: json['super_category_ar_title'] as String?,
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
    'category_title': categoryTitle,
    'category_ar_title': categoryArTitle,
    'super_category_title': superCategoryTitle,
    'super_category_ar_title': superCategoryArTitle,
  };
}
