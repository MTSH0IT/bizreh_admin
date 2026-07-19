class SubCategory {
  String? name;
  String? arName;

  SubCategory({this.name, this.arName});

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    name: json['name'] as String?,
    arName: json['ar_name'] as String?,
  );

  Map<String, dynamic> toJson() => {'name': name, 'ar_name': arName};
}
