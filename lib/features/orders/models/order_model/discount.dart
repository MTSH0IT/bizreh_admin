class Discount {
  int? id;
  String? title;
  String? arTitle;
  int? amount;
  String? amountType;

  Discount({this.id, this.title, this.arTitle, this.amount, this.amountType});

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
    id: json['id'] as int?,
    title: json['title'] as String?,
    arTitle: json['ar_title'] as String?,
    amount: json['amount'] as int?,
    amountType: json['amount_type'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ar_title': arTitle,
    'amount': amount,
    'amount_type': amountType,
  };
}
