class Summary {
  int? totalRegularPayments;
  int? totalBonus;
  int? totalTransactions;

  Summary({this.totalRegularPayments, this.totalBonus, this.totalTransactions});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalRegularPayments: json['total_regular_payments'] as int?,
    totalBonus: json['total_bonus'] as int?,
    totalTransactions: json['total_transactions'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'total_regular_payments': totalRegularPayments,
    'total_bonus': totalBonus,
    'total_transactions': totalTransactions,
  };
}
