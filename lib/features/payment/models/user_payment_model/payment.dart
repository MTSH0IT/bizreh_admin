class Payment {
  int? id;
  int? userId;
  String? amount;
  String? type;
  String? notes;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  Payment({
    this.id,
    this.userId,
    this.amount,
    this.type,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    amount: json['amount'] as String?,
    type: json['type'] as String?,
    notes: json['notes'] as String?,
    createdBy: json['created_by'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'amount': amount,
    'type': type,
    'notes': notes,
    'created_by': createdBy,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
  };
}
