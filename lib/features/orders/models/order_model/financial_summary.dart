class FinancialSummary {
  double? subTotal;
  double? totalDiscount;
  double? total;

  FinancialSummary({this.subTotal, this.totalDiscount, this.total});

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      subTotal: (json['sub_total'] as num?)?.toDouble(),
      totalDiscount: (json['total_discount'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'sub_total': subTotal,
    'total_discount': totalDiscount,
    'total': total,
  };
}
