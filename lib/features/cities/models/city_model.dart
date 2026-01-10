class CityModel {
  int? id;
  String? title;
  String? arTitle;
  DateTime? createdAt;

  CityModel({this.id, this.title, this.arTitle, this.createdAt});

  @override
  String toString() {
    return 'CityModel(id: $id, title: $title, arTitle: $arTitle, createdAt: $createdAt)';
  }

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    id: json['id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'created_at': createdAt?.toIso8601String(),
  };
}
