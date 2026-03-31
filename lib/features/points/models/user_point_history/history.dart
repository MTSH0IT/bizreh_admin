import 'gift_details.dart';
import 'order_details.dart';

class History {
  int? id;
  int? userId;
  int? points;
  String? pointsType;
  String? referenceType;
  String? referenceTypeAr;
  int? referenceId;
  String? sourceDescription;
  DateTime? createdAt;
  OrderDetails? orderDetails;
  GiftDetails? giftDetails;

  History({
    this.id,
    this.userId,
    this.points,
    this.pointsType,
    this.referenceType,
    this.referenceTypeAr,
    this.referenceId,
    this.sourceDescription,
    this.createdAt,
    this.orderDetails,
    this.giftDetails,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    points: json['points'] as int?,
    pointsType: json['points_type'] as String?,
    referenceType: json['reference_type'] as String?,
    referenceTypeAr: json['reference_type_ar'] as String?,
    referenceId: json['reference_id'] as int?,
    sourceDescription: json['source_description'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    orderDetails: json['order_details'] == null
        ? null
        : OrderDetails.fromJson(json['order_details'] as Map<String, dynamic>),
    giftDetails: json['gift_details'] == null
        ? null
        : GiftDetails.fromJson(json['gift_details'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'points': points,
    'points_type': pointsType,
    'reference_type': referenceType,
    'reference_type_ar': referenceTypeAr,
    'reference_id': referenceId,
    'source_description': sourceDescription,
    'created_at': createdAt?.toIso8601String(),
    'order_details': orderDetails?.toJson(),
    'gift_details': giftDetails?.toJson(),
  };
}
