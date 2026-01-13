class AllCategoryModel {
  int? id;
  String? title;
  String? arTitle;
  String? image;
  int? superCategoryId;
  int? position;
  DateTime? createdAt;
  String? superCategoryTitle;
  String? superCategoryArTitle;

  AllCategoryModel({
    this.id,
    this.title,
    this.arTitle,
    this.image,
    this.superCategoryId,
    this.position,
    this.createdAt,
    this.superCategoryTitle,
    this.superCategoryArTitle,
  });

  @override
  String toString() {
    return 'AllCategoryModel(id: $id, title: $title, arTitle: $arTitle, image: $image, superCategoryId: $superCategoryId, position: $position, createdAt: $createdAt, superCategoryTitle: $superCategoryTitle, superCategoryArTitle: $superCategoryArTitle)';
  }

  factory AllCategoryModel.fromJson(Map<String, dynamic> json) {
    return AllCategoryModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      arTitle: json['ar_title'] as String?,
      image: json['image'] as String?,
      superCategoryId: json['super_category_id'] as int?,
      position: json['position'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      superCategoryTitle: json['super_category_title'] as String?,
      superCategoryArTitle: json['super_category_ar_title'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'image': image,
    'super_category_id': superCategoryId,
    'position': position,
    'created_at': createdAt?.toIso8601String(),
    'super_category_title': superCategoryTitle,
    'super_category_ar_title': superCategoryArTitle,
  };
}
