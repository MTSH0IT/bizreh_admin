class User {
  int? id;
  String? fullName;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? userType;
  DateTime? userSince;

  User({
    this.id,
    this.fullName,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.userType,
    this.userSince,
  });

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, userType: $userType, userSince: $userSince)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int?,
    fullName: json['full_name'] as String?,
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    userType: json['user_type'] as String?,
    userSince: json['user_since'] == null
        ? null
        : DateTime.parse(json['user_since'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'user_type': userType,
    'user_since': userSince?.toIso8601String(),
  };
}
