class SubCategory {
	int? id;
	String? title;
	String? arTitle;

	SubCategory({this.id, this.title, this.arTitle});

	factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
				id: json['id'] as int?,
				title: json['title'] as String?,
				arTitle: json['ar_title'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'title': title,
				'ar_title': arTitle,
			};
}
