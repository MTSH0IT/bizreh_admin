class UserPointHistoyModel {
  int? id;
  int? userId;
  int? points;
  String? pointsType;
  String? referenceType;
  int? referenceId;
  dynamic sourceDescription;
  DateTime? createdAt;
  int? orderId;
  int? userGiftId;

  UserPointHistoyModel({
    this.id,
    this.userId,
    this.points,
    this.pointsType,
    this.referenceType,
    this.referenceId,
    this.sourceDescription,
    this.createdAt,
    this.orderId,
    this.userGiftId,
  });

  factory UserPointHistoyModel.fromJson(Map<String, dynamic> json) {
    return UserPointHistoyModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      points: json['points'] as int?,
      pointsType: json['points_type'] as String?,
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id'] as int?,
      sourceDescription: json['source_description'] as dynamic,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      orderId: json['order_id'] as int?,
      userGiftId: json['user_gift_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'points': points,
    'points_type': pointsType,
    'reference_type': referenceType,
    'reference_id': referenceId,
    'source_description': sourceDescription,
    'created_at': createdAt?.toIso8601String(),
    'order_id': orderId,
    'user_gift_id': userGiftId,
  };
}
