import 'brand.dart';
import 'sub_category.dart';

class Product {
  int? id;
  String? title;
  String? arTitle;
  Brand? brand;
  SubCategory? subCategory;

  Product({this.id, this.title, this.arTitle, this.brand, this.subCategory});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    brand: json['brand'] == null
        ? null
        : Brand.fromJson(json['brand'] as Map<String, dynamic>),
    subCategory: json['sub_category'] == null
        ? null
        : SubCategory.fromJson(json['sub_category'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'brand': brand?.toJson(),
    'sub_category': subCategory?.toJson(),
  };
}
