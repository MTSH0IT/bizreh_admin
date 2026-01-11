class OrderModel {
  int? id;
  String? orderNumber;
  int? userId;
  int? addressId;
  dynamic driverId;
  double? totalAmount;
  String? status;
  String? paymentStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic supplierId;
  String? cityName;
  String? userName;
  String? userEmail;
  dynamic driverName;
  String? addressLine;
  String? note;

  OrderModel({
    this.id,
    this.orderNumber,
    this.userId,
    this.addressId,
    this.driverId,
    this.totalAmount,
    this.status,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
    this.supplierId,
    this.cityName,
    this.userName,
    this.userEmail,
    this.driverName,
    this.addressLine,
    this.note,
  });

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, userId: $userId, addressId: $addressId, driverId: $driverId, totalAmount: $totalAmount, status: $status, paymentStatus: $paymentStatus, createdAt: $createdAt, updatedAt: $updatedAt, supplierId: $supplierId, cityName: $cityName, userName: $userName, userEmail: $userEmail, driverName: $driverName, addressLine: $addressLine, note: $note)';
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'] as int?,
    orderNumber: json['order_number'] as String?,
    userId: json['user_id'] as int?,
    addressId: json['address_id'] as int?,
    driverId: json['driver_id'] as dynamic,
    totalAmount: (json['total_amount'] as num?)?.toDouble(),
    status: json['status'] as String?,
    paymentStatus: json['payment_status'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    supplierId: json['supplier_id'] as dynamic,
    cityName: json['city_name'] as String?,
    userName: json['user_name'] as String?,
    userEmail: json['user_email'] as String?,
    driverName: json['driver_name'] as dynamic,
    addressLine: json['address_line'] as String?,
    note: json['note'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_number': orderNumber,
    'user_id': userId,
    'address_id': addressId,
    'driver_id': driverId,
    'total_amount': totalAmount,
    'status': status,
    'payment_status': paymentStatus,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'supplier_id': supplierId,
    'city_name': cityName,
    'user_name': userName,
    'user_email': userEmail,
    'driver_name': driverName,
    'address_line': addressLine,
    'note': note,
  };
}
