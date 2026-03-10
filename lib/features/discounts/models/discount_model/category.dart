class Category {
  int? categoryId;
  String? categoryType;
  String? categoryTitle;
  String? categoryArTitle;

  Category({
    this.categoryId,
    this.categoryType,
    this.categoryTitle,
    this.categoryArTitle,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json['category_id'] as int?,
    categoryType: json['category_type'] as String?,
    categoryTitle: json['category_title'] as String?,
    categoryArTitle: json['category_ar_title'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'category_id': categoryId,
    'category_type': categoryType,
    'category_title': categoryTitle,
    'category_ar_title': categoryArTitle,
  };
}
