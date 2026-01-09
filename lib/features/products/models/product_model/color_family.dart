class ColorFamily {
  int? id;
  String? colorDegree;
  DateTime? createdAt;

  ColorFamily({this.id, this.colorDegree, this.createdAt});

  factory ColorFamily.fromJson(Map<String, dynamic> json) => ColorFamily(
    id: json['id'] as int?,
    colorDegree: json['color_degree'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'color_degree': colorDegree,
    'created_at': createdAt?.toIso8601String(),
  };
}
