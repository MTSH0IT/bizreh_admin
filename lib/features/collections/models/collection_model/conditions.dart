class Conditions {
  dynamic subCategory;
  dynamic brand;
  List<String>? tags;

  Conditions({this.subCategory, this.brand, this.tags});

  factory Conditions.fromJson(Map<String, dynamic> json) => Conditions(
    subCategory: json['sub_category'],
    brand: json['brand'],
    tags: _parseTags(json['tags']),
  );

  static List<String>? _parseTags(dynamic raw) {
    if (raw == null) return null;
    if (raw is List) {
      return raw
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final text = raw.toString().trim();
    if (text.isEmpty) return <String>[];
    return text
        .split(RegExp(r'[,\n\u060C]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> toJson() => {
    'sub_category': subCategory,
    'brand': brand,
    'tags': tags,
  };
}
