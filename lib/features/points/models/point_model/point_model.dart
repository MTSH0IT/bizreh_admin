import 'brand.dart';
import 'category.dart';
import 'product.dart';

class PointModel {
  int? id;
  String? title;
  String? arTitle;
  String? type;
  int? amount;
  int? pointsAmount;
  String? minPurchaseAmount;
  int? maxPointsPerUser;
  String? amountType;
  DateTime? exprationDate;
  String? roleType;
  int? isActive;
  DateTime? createdAt;
  int? productsCount;
  int? brandsCount;
  int? categoriesCount;
  List<Product>? products;
  List<Brand>? brands;
  List<Category>? categories;

  PointModel({
    this.id,
    this.title,
    this.arTitle,
    this.type,
    this.amount,
    this.pointsAmount,
    this.minPurchaseAmount,
    this.maxPointsPerUser,
    this.amountType,
    this.exprationDate,
    this.roleType,
    this.isActive,
    this.createdAt,
    this.productsCount,
    this.brandsCount,
    this.categoriesCount,
    this.products,
    this.brands,
    this.categories,
  });

  @override
  String toString() {
    return 'PointModel(id: $id, title: $title, arTitle: $arTitle, type: $type, amount: $amount, pointsAmount: $pointsAmount, minPurchaseAmount: $minPurchaseAmount, maxPointsPerUser: $maxPointsPerUser, amountType: $amountType, exprationDate: $exprationDate, roleType: $roleType, isActive: $isActive, createdAt: $createdAt, productsCount: $productsCount, brandsCount: $brandsCount, categoriesCount: $categoriesCount, products: $products, brands: $brands, categories: $categories)';
  }

  factory PointModel.fromJson(Map<String, dynamic> json) => PointModel(
    id: json['id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    type: json['type'] as String?,
    amount: json['amount'] as int?,
    pointsAmount: json['points_amount'] as int?,
    minPurchaseAmount: json['min_purchase_amount'] as String?,
    maxPointsPerUser: json['max_points_per_user'] as int?,
    amountType: json['amount_type'] as String?,
    exprationDate: json['expration_date'] == null
        ? null
        : DateTime.parse(json['expration_date'] as String),
    roleType: json['role_type'] as String?,
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
    'type': type,
    'amount': amount,
    'points_amount': pointsAmount,
    'min_purchase_amount': minPurchaseAmount,
    'max_points_per_user': maxPointsPerUser,
    'amount_type': amountType,
    'expration_date': exprationDate?.toIso8601String(),
    'role_type': roleType,
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
