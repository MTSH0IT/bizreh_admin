class Summary {
  int? year;
  double? totalPayments;
  double? totalBonus;
  int? ordersCount;
  double? ordersTotal;

  Summary({
    this.year,
    this.totalPayments,
    this.totalBonus,
    this.ordersCount,
    this.ordersTotal,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    year: json['year'] as int?,
    totalPayments: (json['total_payments'] as num?)?.toDouble(),
    totalBonus: (json['total_bonus'] as num?)?.toDouble(),
    ordersCount: json['orders_count'] as int?,
    ordersTotal: (json['orders_total'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'year': year,
    'total_payments': totalPayments,
    'total_bonus': totalBonus,
    'orders_count': ordersCount,
    'orders_total': ordersTotal,
  };
}
