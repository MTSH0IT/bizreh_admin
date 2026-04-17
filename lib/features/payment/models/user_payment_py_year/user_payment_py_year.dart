import 'summary.dart';
import 'user.dart';
import 'suggested_bonus.dart';

class UserPaymentPyYear {
  User? user;
  Summary? summary;
  SuggestedBonus? suggestedBonus;

  UserPaymentPyYear({this.user, this.summary, this.suggestedBonus});

  factory UserPaymentPyYear.fromJson(Map<String, dynamic> json) {
    return UserPaymentPyYear(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      summary: json['summary'] == null
          ? null
          : Summary.fromJson(json['summary'] as Map<String, dynamic>),
      suggestedBonus: json['suggested_bonus'] == null
          ? null
          : SuggestedBonus.fromJson(
              json['suggested_bonus'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user?.toJson(),
    'summary': summary?.toJson(),
    'suggested_bonus': suggestedBonus?.toJson(),
  };
}
