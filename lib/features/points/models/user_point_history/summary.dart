class Summary {
  int? totalEarned;
  int? totalSpent;
  int? currentBalance;
  int? totalTransactions;

  Summary({
    this.totalEarned,
    this.totalSpent,
    this.currentBalance,
    this.totalTransactions,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalEarned: json['total_earned'] as int?,
    totalSpent: json['total_spent'] as int?,
    currentBalance: json['current_balance'] as int?,
    totalTransactions: json['total_transactions'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'total_earned': totalEarned,
    'total_spent': totalSpent,
    'current_balance': currentBalance,
    'total_transactions': totalTransactions,
  };
}
