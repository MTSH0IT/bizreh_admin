class Color {
  int? id;
  String? name;
  String? arName;
  String? degree;

  Color({this.id, this.name, this.arName, this.degree});

  @override
  String toString() {
    return 'Color(id: $id, name: $name, arName: $arName, degree: $degree)';
  }

  factory Color.fromJson(Map<String, dynamic> json) => Color(
    id: json['id'] as int?,
    name: json['name'] as String?,
    arName: json['ar_name'] as String?,
    degree: json['degree'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ar_name': arName,
    'degree': degree,
  };
}
