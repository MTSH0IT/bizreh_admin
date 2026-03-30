import 'item.dart';

class OffersCartModel {
	int? id;
	String? name;
	String? arName;
	String? description;
	String? arDescription;
	String? price;
	int? quantity;
	int? isActive;
	DateTime? createdAt;
	DateTime? updatedAt;
	int? itemsCount;
	int? calculatedTotal;
	int? savings;
	List<Item>? items;

	OffersCartModel({
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
		this.calculatedTotal, 
		this.savings, 
		this.items, 
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
						: DateTime.parse(json['created_at'] as String),
			updatedAt: json['updated_at'] == null
						? null
						: DateTime.parse(json['updated_at'] as String),
			itemsCount: json['items_count'] as int?,
			calculatedTotal: json['calculated_total'] as int?,
			savings: json['savings'] as int?,
			items: (json['items'] as List<dynamic>?)
						?.map((e) => Item.fromJson(e as Map<String, dynamic>))
						.toList(),
		);
	}



	Map<String, dynamic> toJson() => {
				'id': id,
				'name': name,
				'ar_name': arName,
				'description': description,
				'ar_description': arDescription,
				'price': price,
				'quantity': quantity,
				'is_active': isActive,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
				'items_count': itemsCount,
				'calculated_total': calculatedTotal,
				'savings': savings,
				'items': items?.map((e) => e.toJson()).toList(),
			};
}
