import 'history.dart';
import 'summary.dart';

class UserPointHistory {
  List<History>? history;
  Summary? summary;

  UserPointHistory({this.history, this.summary});

  factory UserPointHistory.fromJson(Map<String, dynamic> json) {
    return UserPointHistory(
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => History.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] == null
          ? null
          : Summary.fromJson(json['summary'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'history': history?.map((e) => e.toJson()).toList(),
    'summary': summary?.toJson(),
  };
}
