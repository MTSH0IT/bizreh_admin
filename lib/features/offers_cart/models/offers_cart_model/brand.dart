class Brand {
	int? id;
	String? title;
	String? arTitle;

	Brand({this.id, this.title, this.arTitle});

	factory Brand.fromJson(Map<String, dynamic> json) => Brand(
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
