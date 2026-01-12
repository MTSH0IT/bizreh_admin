class ColorModel {
  int? id;
  String? name;
  String? arName;
  String? colorDegree;
  DateTime? createdAt;

  ColorModel({
    this.id,
    this.name,
    this.arName,
    this.colorDegree,
    this.createdAt,
  });

  @override
  String toString() {
    return 'ColorModel(id: $id, name: $name, arName: $arName, colorDegree: $colorDegree, createdAt: $createdAt)';
  }

  factory ColorModel.fromJson(Map<String, dynamic> json) => ColorModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    arName: json['ar_name'] as String?,
    colorDegree: json['color_degree'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ar_name': arName,
    'color_degree': colorDegree,
    'created_at': createdAt?.toIso8601String(),
  };
}
