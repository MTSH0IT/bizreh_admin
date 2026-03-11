class UserPointsBalanceModel {
  int? userId;
  String? totalPointsEarned;
  String? totalPointsUsed;
  String? availablePoints;
  int? totalTransactions;

  UserPointsBalanceModel({
    this.userId,
    this.totalPointsEarned,
    this.totalPointsUsed,
    this.availablePoints,
    this.totalTransactions,
  });

  factory UserPointsBalanceModel.fromJson(Map<String, dynamic> json) {
    return UserPointsBalanceModel(
      userId: json['user_id'] as int?,
      totalPointsEarned: json['total_points_earned'] as String?,
      totalPointsUsed: json['total_points_used'] as String?,
      availablePoints: json['available_points'] as String?,
      totalTransactions: json['total_transactions'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'total_points_earned': totalPointsEarned,
    'total_points_used': totalPointsUsed,
    'available_points': availablePoints,
    'total_transactions': totalTransactions,
  };
}
