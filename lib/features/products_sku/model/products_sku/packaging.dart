class Packaging {
  int? id;
  String? title;
  String? arTitle;

  Packaging({this.id, this.title, this.arTitle});

  factory Packaging.fromJson(Map<String, dynamic> json) => Packaging(
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
