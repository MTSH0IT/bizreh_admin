class SuggestedBonus {
  double? percentage;
  String? calculatedAmount;

  SuggestedBonus({this.percentage, this.calculatedAmount});

  factory SuggestedBonus.fromJson(Map<String, dynamic> json) => SuggestedBonus(
    percentage: (json['percentage'] as num?)?.toDouble(),
    calculatedAmount: json['calculated_amount'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'percentage': percentage,
    'calculated_amount': calculatedAmount,
  };
}
