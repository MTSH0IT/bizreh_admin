class BrandsModel {
	int? id;
	String? title;
	String? arTitle;
	String? image;
	int? position;
	DateTime? createdAt;
	int? productsCount;

	BrandsModel({
		this.id, 
		this.title, 
		this.arTitle, 
		this.image, 
		this.position, 
		this.createdAt, 
		this.productsCount, 
	});

	@override
	String toString() {
		return 'BrandsModel(id: $id, title: $title, arTitle: $arTitle, image: $image, position: $position, createdAt: $createdAt, productsCount: $productsCount)';
	}

	factory BrandsModel.fromJson(Map<String, dynamic> json) => BrandsModel(
				id: json['id'] as int?,
				title: json['title'] as String?,
				arTitle: json['ar_title'] as String?,
				image: json['image'] as String?,
				position: json['position'] as int?,
				createdAt: json['created_at'] == null
						? null
						: DateTime.parse(json['created_at'] as String),
				productsCount: json['products_count'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'title': title,
				'ar_title': arTitle,
				'image': image,
				'position': position,
				'created_at': createdAt?.toIso8601String(),
				'products_count': productsCount,
			};
}
