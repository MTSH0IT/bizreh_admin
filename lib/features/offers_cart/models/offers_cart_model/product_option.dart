class ProductOption {
	int? id;
	String? name;
	String? arName;
	String? mainImage;

	ProductOption({this.id, this.name, this.arName, this.mainImage});

	factory ProductOption.fromJson(Map<String, dynamic> json) => ProductOption(
				id: json['id'] as int?,
				name: json['name'] as String?,
				arName: json['ar_name'] as String?,
				mainImage: json['main_image'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'name': name,
				'ar_name': arName,
				'main_image': mainImage,
			};
}
