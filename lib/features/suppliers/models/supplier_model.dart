class SupplierModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  int? isActive;
  DateTime? createdAt;
  String? cities;
  int? driversCount;
  int? ordersCount;
  int? totalSales;

  SupplierModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.isActive,
    this.createdAt,
    this.cities,
    this.driversCount,
    this.ordersCount,
    this.totalSales,
  });

  @override
  String toString() {
    return 'SupplierModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, isActive: $isActive, createdAt: $createdAt, cities: $cities, driversCount: $driversCount, ordersCount: $ordersCount, totalSales: $totalSales)';
  }

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
    id: json['id'] as int?,
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    isActive: json['is_active'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    cities: json['cities'] as String?,
    driversCount: json['drivers_count'] as int?,
    ordersCount: json['orders_count'] as int?,
    totalSales: json['total_sales'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'cities': cities,
    'drivers_count': driversCount,
    'orders_count': ordersCount,
    'total_sales': totalSales,
  };
}
