class SuperCategoryModel {
  int? id;
  String? title;
  String? arTitle;
  String? image;
  int? position;
  DateTime? createdAt;

  SuperCategoryModel({
    this.id,
    this.title,
    this.arTitle,
    this.image,
    this.position,
    this.createdAt,
  });

  @override
  String toString() {
    return 'SuperCategoryModel(id: $id, title: $title, arTitle: $arTitle, image: $image, position: $position, createdAt: $createdAt)';
  }

  factory SuperCategoryModel.fromJson(Map<String, dynamic> json) {
    return SuperCategoryModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      arTitle: json['ar_title'] as String?,
      image: json['image'] as String?,
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
    'position': position,
    'created_at': createdAt?.toIso8601String(),
  };
}
