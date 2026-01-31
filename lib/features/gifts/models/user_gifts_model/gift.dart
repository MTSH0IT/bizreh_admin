class Gift {
  int? id;
  String? title;
  String? arTitle;
  int? points;
  String? image;

  Gift({this.id, this.title, this.arTitle, this.points, this.image});

  @override
  String toString() {
    return 'Gift(id: $id, title: $title, arTitle: $arTitle, points: $points, image: $image)';
  }

  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
    id: json['id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    points: json['points'] as int?,
    image: json['image'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'points': points,
    'image': image,
  };
}
