class Packaging {
  int? id;
  String? sku;
  String? title;
  String? arTitle;

  Packaging({this.id, this.sku, this.title, this.arTitle});

  factory Packaging.fromJson(Map<String, dynamic> json) => Packaging(
    id: json['id'] as int?,
    sku: json['sku'] as String?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'sku': sku,
    'title': title,
    'ar_title': arTitle,
  };
}
