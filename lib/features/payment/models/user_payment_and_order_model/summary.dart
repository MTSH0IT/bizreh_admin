class Summary {
  double? totalOrdersAmount;
  double? totalRegularPayments;
  double? totalBonus;
  double? balanceDue;
  int? ordersCount;
  int? paymentsCount;

  Summary({
    this.totalOrdersAmount,
    this.totalRegularPayments,
    this.totalBonus,
    this.balanceDue,
    this.ordersCount,
    this.paymentsCount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalOrdersAmount: (json['total_orders_amount'] as num?)?.toDouble(),
    totalRegularPayments: (json['total_regular_payments'] as num?)?.toDouble(),
    totalBonus: (json['total_bonus'] as num?)?.toDouble(),
    balanceDue: (json['balance_due'] as num?)?.toDouble(),
    ordersCount: json['orders_count'] as int?,
    paymentsCount: json['payments_count'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'total_orders_amount': totalOrdersAmount,
    'total_regular_payments': totalRegularPayments,
    'total_bonus': totalBonus,
    'balance_due': balanceDue,
    'orders_count': ordersCount,
    'payments_count': paymentsCount,
  };
}
