import 'color.dart';
import 'packaging.dart';
import 'product.dart';
import 'product_option.dart';

class Item {
	int? id;
	int? optionPackagingId;
	int? quantity;
	int? pricePerUnit;
	int? totalPrice;
	DateTime? createdAt;
	Packaging? packaging;
	ProductOption? productOption;
	Product? product;
	Color? color;
	int? stockQuantity;

	Item({
		this.id, 
		this.optionPackagingId, 
		this.quantity, 
		this.pricePerUnit, 
		this.totalPrice, 
		this.createdAt, 
		this.packaging, 
		this.productOption, 
		this.product, 
		this.color, 
		this.stockQuantity, 
	});

	factory Item.fromJson(Map<String, dynamic> json) => Item(
				id: json['id'] as int?,
				optionPackagingId: json['option_packaging_id'] as int?,
				quantity: json['quantity'] as int?,
				pricePerUnit: json['price_per_unit'] as int?,
				totalPrice: json['total_price'] as int?,
				createdAt: json['created_at'] == null
						? null
						: DateTime.parse(json['created_at'] as String),
				packaging: json['packaging'] == null
						? null
						: Packaging.fromJson(json['packaging'] as Map<String, dynamic>),
				productOption: json['product_option'] == null
						? null
						: ProductOption.fromJson(json['product_option'] as Map<String, dynamic>),
				product: json['product'] == null
						? null
						: Product.fromJson(json['product'] as Map<String, dynamic>),
				color: json['color'] == null
						? null
						: Color.fromJson(json['color'] as Map<String, dynamic>),
				stockQuantity: json['stock_quantity'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'option_packaging_id': optionPackagingId,
				'quantity': quantity,
				'price_per_unit': pricePerUnit,
				'total_price': totalPrice,
				'created_at': createdAt?.toIso8601String(),
				'packaging': packaging?.toJson(),
				'product_option': productOption?.toJson(),
				'product': product?.toJson(),
				'color': color?.toJson(),
				'stock_quantity': stockQuantity,
			};
}
