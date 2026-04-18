class Payment {
  int? id;
  String? amount;
  String? type;
  String? notes;
  DateTime? createdAt;

  Payment({this.id, this.amount, this.type, this.notes, this.createdAt});

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'] as int?,
    amount: json['amount'] as String?,
    type: json['type'] as String?,
    notes: json['notes'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'type': type,
    'notes': notes,
    'created_at': createdAt?.toIso8601String(),
  };
}
