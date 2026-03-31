import 'brand.dart';
import 'category.dart';
import 'sub_category.dart';

class Product {
  int? id;
  String? title;
  String? arTitle;
  String? description;
  String? arDescription;
  String? image;
  dynamic tags;
  int? isActive;
  Brand? brand;
  SubCategory? subCategory;
  Category? category;

  Product({
    this.id,
    this.title,
    this.arTitle,
    this.description,
    this.arDescription,
    this.image,
    this.tags,
    this.isActive,
    this.brand,
    this.subCategory,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    description: json['description'] as String?,
    arDescription: json['ar_description'] as String?,
    image: json['image'] as String?,
    tags: json['tags'] as dynamic,
    isActive: json['is_active'] as int?,
    brand: json['brand'] == null
        ? null
        : Brand.fromJson(json['brand'] as Map<String, dynamic>),
    subCategory: json['sub_category'] == null
        ? null
        : SubCategory.fromJson(json['sub_category'] as Map<String, dynamic>),
    category: json['category'] == null
        ? null
        : Category.fromJson(json['category'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'description': description,
    'ar_description': arDescription,
    'image': image,
    'tags': tags,
    'is_active': isActive,
    'brand': brand?.toJson(),
    'sub_category': subCategory?.toJson(),
    'category': category?.toJson(),
  };
}
