class SuggestedBonus {
  int? percentage;
  String? calculatedAmount;
  String? note;

  SuggestedBonus({this.percentage, this.calculatedAmount, this.note});

  factory SuggestedBonus.fromJson(Map<String, dynamic> json) => SuggestedBonus(
    percentage: json['percentage'] as int?,
    calculatedAmount: json['calculated_amount'] as String?,
    note: json['note'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'percentage': percentage,
    'calculated_amount': calculatedAmount,
    'note': note,
  };
}
