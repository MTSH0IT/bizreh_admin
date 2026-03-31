class Category {
  int? id;
  String? title;
  String? arTitle;

  Category({this.id, this.title, this.arTitle});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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
