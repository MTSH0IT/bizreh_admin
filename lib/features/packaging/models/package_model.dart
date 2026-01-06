class PackageModel {
  int? id;
  String? title;
  String? arTitle;
  DateTime? createdAt;

  PackageModel({this.id, this.title, this.arTitle, this.createdAt});

  @override
  String toString() {
    return 'PackageModel(id: $id, title: $title, arTitle: $arTitle, createdAt: $createdAt)';
  }

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
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
