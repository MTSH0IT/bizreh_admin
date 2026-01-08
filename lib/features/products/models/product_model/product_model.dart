import 'option.dart';

class ProductModel {
  int? id;
  String? title;
  String? arTitle;
  String? description;
  String? arDescription;
  String? image;
  int? subCategoryId;
  int? brandId;
  int? isActive;
  DateTime? createdAt;
  String? brandName;
  String? arBrandName;
  String? subCategoryName;
  String? arSubCategoryName;
  String? categoryName;
  String? arCategoryName;
  String? superCategoryName;
  String? arSuperCategoryName;
  List<Option>? options;

  ProductModel({
    this.id,
    this.title,
    this.arTitle,
    this.description,
    this.arDescription,
    this.image,
    this.subCategoryId,
    this.brandId,
    this.isActive,
    this.createdAt,
    this.brandName,
    this.arBrandName,
    this.subCategoryName,
    this.arSubCategoryName,
    this.categoryName,
    this.arCategoryName,
    this.superCategoryName,
    this.arSuperCategoryName,
    this.options,
  });

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, arTitle: $arTitle, description: $description, arDescription: $arDescription, image: $image, subCategoryId: $subCategoryId, brandId: $brandId, isActive: $isActive, createdAt: $createdAt, brandName: $brandName, arBrandName: $arBrandName, subCategoryName: $subCategoryName, arSubCategoryName: $arSubCategoryName, categoryName: $categoryName, arCategoryName: $arCategoryName, superCategoryName: $superCategoryName, arSuperCategoryName: $arSuperCategoryName, options: $options)';
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    description: json['description'] as String?,
    arDescription: json['ar_description'] as String?,
    image: json['image'] as String?,
    subCategoryId: json['sub_category_id'] as int?,
    brandId: json['brand_id'] as int?,
    isActive: json['is_active'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    brandName: json['brand_name'] as String?,
    arBrandName: json['ar_brand_name'] as String?,
    subCategoryName: json['sub_category_name'] as String?,
    arSubCategoryName: json['ar_sub_category_name'] as String?,
    categoryName: json['category_name'] as String?,
    arCategoryName: json['ar_category_name'] as String?,
    superCategoryName: json['super_category_name'] as String?,
    arSuperCategoryName: json['ar_super_category_name'] as String?,
    options: (json['options'] as List<dynamic>?)
        ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'description': description,
    'ar_description': arDescription,
    'image': image,
    'sub_category_id': subCategoryId,
    'brand_id': brandId,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'brand_name': brandName,
    'ar_brand_name': arBrandName,
    'sub_category_name': subCategoryName,
    'ar_sub_category_name': arSubCategoryName,
    'category_name': categoryName,
    'ar_category_name': arCategoryName,
    'super_category_name': superCategoryName,
    'ar_super_category_name': arSuperCategoryName,
    'options': options?.map((e) => e.toJson()).toList(),
  };
}
