class ProfileModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? createdAt;

  ProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.createdAt,
  });

  @override
  String toString() {
    return 'ProfileModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, createdAt: $createdAt)';
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json['id'] as int?,
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String?,
    email: json['email'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'created_at': createdAt?.toIso8601String(),
  };
}
