import 'color.dart';
import 'discount.dart';

class Item {
  int? id;
  int? orderId;
  int? optionPackagingId;
  int? quantityPerUnit;
  String? productSku;
  double? unitPrice;
  double? totalPrice;
  double? discountAmount;
  double? finalItemPrice;
  String? appliedDiscountName;
  DateTime? createdAt;
  int? productId;
  String? title;
  String? arTitle;
  String? description;
  String? arDescription;
  String? image;
  int? subCategoryId;
  int? brandId;
  int? isActive;
  int? productOptionId;
  String? optionName;
  String? arOptionName;
  String? optionSku;
  String? mainImage;
  int? stockQuantity;
  int? packagingId;
  String? packagingTitle;
  String? packagingArTitle;
  Color? color;
  int? categoryId;
  String? categoryTitle;
  String? categoryArTitle;
  String? brandTitle;
  String? brandArTitle;
  Discount? discount;

  Item({
    this.id,
    this.orderId,
    this.optionPackagingId,
    this.quantityPerUnit,
    this.productSku,
    this.unitPrice,
    this.totalPrice,
    this.discountAmount,
    this.finalItemPrice,
    this.appliedDiscountName,
    this.createdAt,
    this.productId,
    this.title,
    this.arTitle,
    this.description,
    this.arDescription,
    this.image,
    this.subCategoryId,
    this.brandId,
    this.isActive,
    this.productOptionId,
    this.optionName,
    this.arOptionName,
    this.optionSku,
    this.mainImage,
    this.stockQuantity,
    this.packagingId,
    this.packagingTitle,
    this.packagingArTitle,
    this.color,
    this.categoryId,
    this.categoryTitle,
    this.categoryArTitle,
    this.brandTitle,
    this.brandArTitle,
    this.discount,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'] as int?,
    orderId: json['order_id'] as int?,
    optionPackagingId: json['option_packaging_id'] as int?,
    quantityPerUnit: json['quantity_per_unit'] as int?,
    productSku: json['product_sku'] as String?,
    unitPrice: (json['unit_price'] as num?)?.toDouble(),
    totalPrice: (json['total_price'] as num?)?.toDouble(),
    discountAmount: (json['discount_amount'] as num?)?.toDouble(),
    finalItemPrice: (json['final_item_price'] as num?)?.toDouble(),
    appliedDiscountName: json['applied_discount_name'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    productId: json['product_id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    description: json['description'] as String?,
    arDescription: json['ar_description'] as String?,
    image: json['image'] as String?,
    subCategoryId: json['sub_category_id'] as int?,
    brandId: json['brand_id'] as int?,
    isActive: json['is_active'] as int?,
    productOptionId: json['product_option_id'] as int?,
    optionName: json['option_name'] as String?,
    arOptionName: json['ar_option_name'] as String?,
    optionSku: json['option_sku'] as String?,
    mainImage: json['main_image'] as String?,
    stockQuantity: json['stock_quantity'] as int?,
    packagingId: json['packaging_id'] as int?,
    packagingTitle: json['packaging_title'] as String?,
    packagingArTitle: json['packaging_ar_title'] as String?,
    color: json['color'] == null
        ? null
        : Color.fromJson(json['color'] as Map<String, dynamic>),
    categoryId: json['category_id'] as int?,
    categoryTitle: json['category_title'] as String?,
    categoryArTitle: json['category_ar_title'] as String?,
    brandTitle: json['brand_title'] as String?,
    brandArTitle: json['brand_ar_title'] as String?,
    discount: json['discount'] == null
        ? null
        : Discount.fromJson(json['discount'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_id': orderId,
    'option_packaging_id': optionPackagingId,
    'quantity_per_unit': quantityPerUnit,
    'product_sku': productSku,
    'unit_price': unitPrice,
    'total_price': totalPrice,
    'discount_amount': discountAmount,
    'final_item_price': finalItemPrice,
    'applied_discount_name': appliedDiscountName,
    'created_at': createdAt?.toIso8601String(),
    'product_id': productId,
    'title': title,
    'ar_title': arTitle,
    'description': description,
    'ar_description': arDescription,
    'image': image,
    'sub_category_id': subCategoryId,
    'brand_id': brandId,
    'is_active': isActive,
    'product_option_id': productOptionId,
    'option_name': optionName,
    'ar_option_name': arOptionName,
    'option_sku': optionSku,
    'main_image': mainImage,
    'stock_quantity': stockQuantity,
    'packaging_id': packagingId,
    'packaging_title': packagingTitle,
    'packaging_ar_title': packagingArTitle,
    'color': color?.toJson(),
    'category_id': categoryId,
    'category_title': categoryTitle,
    'category_ar_title': categoryArTitle,
    'brand_title': brandTitle,
    'brand_ar_title': brandArTitle,
    'discount': discount?.toJson(),
  };
}
