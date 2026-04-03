class Conditions {
  List<int>? subCategory;
  List<int>? brand;
  List<String>? tags;

  Conditions({this.subCategory, this.brand, this.tags});

  factory Conditions.fromJson(Map<String, dynamic> json) => Conditions(
    subCategory: json['sub_category'] != null
        ? List<int>.from(json['sub_category'].map((x) => x as int))
        : null,
    brand: json['brand'] != null
        ? List<int>.from(json['brand'].map((x) => x as int))
        : null,
    tags: json['tags'] != null
        ? List<String>.from(json['tags'].map((x) => x as String))
        : null,
  );

  Map<String, dynamic> toJson() => {
    'sub_category': subCategory,
    'brand': brand,
    'tags': tags,
  };
}
