class Product {
  int? id;
  String? title;
  String? arTitle;
  String? image;

  Product({this.id, this.title, this.arTitle, this.image});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    image: json['image'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'image': image,
  };
}
