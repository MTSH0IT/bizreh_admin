class UserModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? userType;
  DateTime? createdAt;
  int? isActive;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.userType,
    this.createdAt,
    this.isActive,
  });

  @override
  String toString() {
    return 'UserModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, userType: $userType, createdAt: $createdAt, isActive: $isActive)';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int?,
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    userType: json['user_type'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    isActive: json['is_active'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'user_type': userType,
    'created_at': createdAt?.toIso8601String(),
    'is_active': isActive,
  };
}
