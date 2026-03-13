class UserPointsBalanceModel {
  int? userId;
  int? totalPointsEarned;
  int? totalPointsUsed;
  int? availablePoints;
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
      totalPointsEarned: json['total_points_earned'] as int?,
      totalPointsUsed: json['total_points_used'] as int?,
      availablePoints: json['available_points'] as int?,
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
