class OffersCartModel {
  final int? id;
  final String? name;
  final String? arName;
  final String? description;
  final String? arDescription;
  final String? price;
  final int? quantity;
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? itemsCount;

  const OffersCartModel({
    this.id,
    this.name,
    this.arName,
    this.description,
    this.arDescription,
    this.price,
    this.quantity,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.itemsCount,
  });

  factory OffersCartModel.fromJson(Map<String, dynamic> json) {
    return OffersCartModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      arName: json['ar_name'] as String?,
      description: json['description'] as String?,
      arDescription: json['ar_description'] as String?,
      price: json['price'] as String?,
      quantity: json['quantity'] as int?,
      isActive: json['is_active'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'] as String),
      itemsCount: json['items_count'] as int?,
    );
  }
}
