import 'brand.dart';
import 'category.dart';
import 'product.dart';

class DiscountModel {
  int? id;
  String? title;
  String? arTitle;
  num? amount;
  num? minPurchaseAmount;
  int? minQuantity;
  String? amountType;
  DateTime? expirationDate;
  int? isActive;
  DateTime? createdAt;
  int? productsCount;
  int? brandsCount;
  int? categoriesCount;
  List<Product>? products;
  List<Brand>? brands;
  List<Category>? categories;

  DiscountModel({
    this.id,
    this.title,
    this.arTitle,
    this.amount,
    this.minPurchaseAmount,
    this.minQuantity,
    this.amountType,
    this.expirationDate,
    this.isActive,
    this.createdAt,
    this.productsCount,
    this.brandsCount,
    this.categoriesCount,
    this.products,
    this.brands,
    this.categories,
  });

  static num? _parseNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
    id: json['id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    amount: _parseNum(json['amount']),
    minPurchaseAmount: _parseNum(json['min_purchase_amount']),
    minQuantity: json['min_quantity'] as int?,
    amountType: json['amount_type'] as String?,
    expirationDate: json['expiration_date'] == null
        ? null
        : DateTime.parse(json['expiration_date'] as String),
    isActive: json['is_active'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    productsCount: json['products_count'] as int?,
    brandsCount: json['brands_count'] as int?,
    categoriesCount: json['categories_count'] as int?,
    products: (json['products'] as List<dynamic>?)
        ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList(),
    brands: (json['brands'] as List<dynamic>?)
        ?.map((e) => Brand.fromJson(e as Map<String, dynamic>))
        .toList(),
    categories: (json['categories'] as List<dynamic>?)
        ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'amount': amount,
    'min_purchase_amount': minPurchaseAmount,
    'min_quantity': minQuantity,
    'amount_type': amountType,
    'expiration_date': expirationDate?.toIso8601String(),
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'products_count': productsCount,
    'brands_count': brandsCount,
    'categories_count': categoriesCount,
    'products': products?.map((e) => e.toJson()).toList(),
    'brands': brands?.map((e) => e.toJson()).toList(),
    'categories': categories?.map((e) => e.toJson()).toList(),
  };
}
