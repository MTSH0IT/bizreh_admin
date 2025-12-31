import 'brand.dart';

class BrandProductsModel {
  Brand? brand;
  List<dynamic>? products;
  int? productsCount;

  BrandProductsModel({this.brand, this.products, this.productsCount});

  @override
  String toString() {
    return 'BrandProductsModel(brand: $brand, products: $products, productsCount: $productsCount)';
  }

  factory BrandProductsModel.fromJson(Map<String, dynamic> json) {
    return BrandProductsModel(
      brand: json['brand'] == null
          ? null
          : Brand.fromJson(json['brand'] as Map<String, dynamic>),
      products: json['products'] as List<dynamic>?,
      productsCount: json['products_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'brand': brand?.toJson(),
    'products': products,
    'products_count': productsCount,
  };
}
