class Conditions {
	int? subCategory;
	int? brand;
	List<String>? tags;

	Conditions({this.subCategory, this.brand, this.tags});

	factory Conditions.fromJson(Map<String, dynamic> json) => Conditions(
				subCategory: json['sub_category'] as int?,
				brand: json['brand'] as int?,
				tags: json['tags'] as List<String>?,
			);

	Map<String, dynamic> toJson() => {
				'sub_category': subCategory,
				'brand': brand,
				'tags': tags,
			};
}
