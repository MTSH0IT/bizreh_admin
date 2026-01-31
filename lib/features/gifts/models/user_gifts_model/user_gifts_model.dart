import 'gift.dart';
import 'user.dart';

class UserGiftsModel {
  int? userGiftId;
  String? userGiftStatus;
  DateTime? createdAt;
  Gift? gift;
  User? user;

  UserGiftsModel({
    this.userGiftId,
    this.userGiftStatus,
    this.createdAt,
    this.gift,
    this.user,
  });

  @override
  String toString() {
    return 'UserGiftsModel(userGiftId: $userGiftId, userGiftStatus: $userGiftStatus, createdAt: $createdAt, gift: $gift, user: $user)';
  }

  factory UserGiftsModel.fromJson(Map<String, dynamic> json) {
    return UserGiftsModel(
      userGiftId: json['user_gift_id'] as int?,
      userGiftStatus: json['user_gift_status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      gift: json['gift'] == null
          ? null
          : Gift.fromJson(json['gift'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_gift_id': userGiftId,
    'user_gift_status': userGiftStatus,
    'created_at': createdAt?.toIso8601String(),
    'gift': gift?.toJson(),
    'user': user?.toJson(),
  };
}
