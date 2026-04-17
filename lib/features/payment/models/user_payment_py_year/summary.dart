class Summary {
  int? year;
  num? totalPayments;
  num? totalBonus;
  num? ordersCount;
  num? ordersTotal;

  Summary({
    this.year,
    this.totalPayments,
    this.totalBonus,
    this.ordersCount,
    this.ordersTotal,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    year: (json['year'] as num?)?.toInt(),
    totalPayments: (json['total_payments'] as num?)?.toDouble(),
    totalBonus: (json['total_bonus'] as num?)?.toDouble(),
    ordersCount: (json['orders_count'] as num?)?.toInt(),
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
