import 'package:bizreh_admin/features/collections/models/collection_model/conditions.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';

class CollectionModel {
  int? id;
  String? title;
  String? arTitle;
  int? parentCollectionId;
  Conditions? conditions;
  String? conditionType;
  String? type;
  String? customProducts;
  String? image;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? parentTitle;
  String? parentArTitle;
  int? subCollectionsCount;
  int? totalProductsCount;
  List<int>? customProductsArray;
  List<CollectionModel>? subCollections;
  List<ProductModel>? products;
  int? productsCount;
  List<int>? productIds;

  CollectionModel({
    this.id,
    this.title,
    this.arTitle,
    this.parentCollectionId,
    this.conditions,
    this.conditionType,
    this.type,
    this.customProducts,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.parentTitle,
    this.parentArTitle,
    this.subCollectionsCount,
    this.totalProductsCount,
    this.customProductsArray,
    this.subCollections,
    this.products,
    this.productsCount,
    this.productIds,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      arTitle: json['ar_title'] as String?,
      parentCollectionId: json['parent_collection_id'] as int?,
      conditions: json['conditions'] == null
          ? null
          : Conditions.fromJson(json['conditions']),
      conditionType: json['condition_type'] as String?,
      type: json['type'] as String?,
      customProducts: json['custom_products'] as dynamic,
      image: json['image'] as String?,
      status: json['status'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      parentTitle: json['parent_title'] as String?,
      parentArTitle: json['parent_ar_title'] as String?,
      subCollectionsCount: json['sub_collections_count'] as int?,
      totalProductsCount: json['total_products_count'] as int?,
      customProductsArray: json['custom_products_array'] != null
          ? List<int>.from(json['custom_products_array'].map((x) => x as int))
          : null,
      subCollections: (json['sub_collections'] as List<dynamic>?)
          ?.map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      productsCount: json['products_count'] as int?,
      productIds: json['product_ids'] != null
          ? List<int>.from(json['product_ids'].map((x) => x as int))
          : null,
    );
  }
}
