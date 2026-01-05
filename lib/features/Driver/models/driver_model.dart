class DriverModel {
  int? driverId;
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? userType;
  int? isActive;
  DateTime? createdAt;
  String? vehicleNumber;
  String? licenseNumber;
  dynamic supplierId;
  int? ordersCount;

  DriverModel({
    this.driverId,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.userType,
    this.isActive,
    this.createdAt,
    this.vehicleNumber,
    this.licenseNumber,
    this.supplierId,
    this.ordersCount,
  });

  @override
  String toString() {
    return 'DriverModel(driverId: $driverId, userId: $userId, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, userType: $userType, isActive: $isActive, createdAt: $createdAt, vehicleNumber: $vehicleNumber, licenseNumber: $licenseNumber, supplierId: $supplierId, ordersCount: $ordersCount)';
  }

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
    driverId: json['driver_id'] as int?,
    userId: json['user_id'] as int?,
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    userType: json['user_type'] as String?,
    isActive: json['is_active'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    vehicleNumber: json['vehicle_number'] as String?,
    licenseNumber: json['license_number'] as String?,
    supplierId: json['supplier_id'] as dynamic,
    ordersCount: json['orders_count'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'driver_id': driverId,
    'user_id': userId,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'user_type': userType,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'vehicle_number': vehicleNumber,
    'license_number': licenseNumber,
    'supplier_id': supplierId,
    'orders_count': ordersCount,
  };
}
