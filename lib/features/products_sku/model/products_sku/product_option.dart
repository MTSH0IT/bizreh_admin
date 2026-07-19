class ProductOption {
  int? id;
  String? optionName;
  String? arOptionName;
  int? productId;

  ProductOption({this.id, this.optionName, this.arOptionName, this.productId});

  factory ProductOption.fromJson(Map<String, dynamic> json) => ProductOption(
    id: json['id'] as int?,
    optionName: json['option_name'] as String?,
    arOptionName: json['ar_option_name'] as String?,
    productId: json['product_id'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'option_name': optionName,
    'ar_option_name': arOptionName,
    'product_id': productId,
  };
}
