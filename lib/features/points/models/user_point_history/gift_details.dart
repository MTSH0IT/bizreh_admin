class GiftDetails {
  int? giftId;
  String? title;
  String? arTitle;
  int? points;
  String? image;
  String? status;
  DateTime? redeemedAt;

  GiftDetails({
    this.giftId,
    this.title,
    this.arTitle,
    this.points,
    this.image,
    this.status,
    this.redeemedAt,
  });

  factory GiftDetails.fromJson(Map<String, dynamic> json) => GiftDetails(
    giftId: json['gift_id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    points: json['points'] as int?,
    image: json['image'] as String?,
    status: json['status'] as String?,
    redeemedAt: json['redeemed_at'] == null
        ? null
        : DateTime.parse(json['redeemed_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'gift_id': giftId,
    'title': title,
    'ar_title': arTitle,
    'points': points,
    'image': image,
    'status': status,
    'redeemed_at': redeemedAt?.toIso8601String(),
  };
}
