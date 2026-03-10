import 'financial_summary.dart';
import 'item.dart';

class OrderModel {
  int? id;
  String? orderNumber;
  int? userId;
  String? userName;
  String? userEmail;
  String? userPhone;
  int? supplierId;
  int? addressId;
  String? addressLine;
  String? addressNote;
  double? longitude;
  double? latitude;
  String? cityName;
  String? arCityName;
  int? driverId;
  String? driverName;
  String? driverPhone;
  String? status;
  String? paymentStatus;
  DateTime? createdAt;
  FinancialSummary? financialSummary;
  int? totalItemsCount;
  List<Item>? items;

  OrderModel({
    this.id,
    this.orderNumber,
    this.userId,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.supplierId,
    this.addressId,
    this.addressLine,
    this.addressNote,
    this.longitude,
    this.latitude,
    this.cityName,
    this.arCityName,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.status,
    this.paymentStatus,
    this.createdAt,
    this.financialSummary,
    this.totalItemsCount,
    this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'] as int?,
    orderNumber: json['order_number'] as String?,
    userId: json['user_id'] as int?,
    userName: json['user_name'] as String?,
    userEmail: json['user_email'] as String?,
    userPhone: json['user_phone'] as String?,
    supplierId: json['supplier_id'] as int?,
    addressId: json['address_id'] as int?,
    addressLine: json['address_line'] as String?,
    addressNote: json['address_note'] as String?,
    longitude: (json['longitude'] as num?)?.toDouble(),
    latitude: (json['latitude'] as num?)?.toDouble(),
    cityName: json['city_name'] as String?,
    arCityName: json['ar_city_name'] as String?,
    driverId: json['driver_id'] as int?,
    driverName: json['driver_name'] as String?,
    driverPhone: json['driver_phone'] as String?,
    status: json['status'] as String?,
    paymentStatus: json['payment_status'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    financialSummary: json['financial_summary'] == null
        ? null
        : FinancialSummary.fromJson(
            json['financial_summary'] as Map<String, dynamic>,
          ),
    totalItemsCount: json['total_items_count'] as int?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_number': orderNumber,
    'user_id': userId,
    'user_name': userName,
    'user_email': userEmail,
    'user_phone': userPhone,
    'supplier_id': supplierId,
    'address_id': addressId,
    'address_line': addressLine,
    'address_note': addressNote,
    'longitude': longitude,
    'latitude': latitude,
    'city_name': cityName,
    'ar_city_name': arCityName,
    'driver_id': driverId,
    'driver_name': driverName,
    'driver_phone': driverPhone,
    'status': status,
    'payment_status': paymentStatus,
    'created_at': createdAt?.toIso8601String(),
    'financial_summary': financialSummary?.toJson(),
    'total_items_count': totalItemsCount,
    'items': items?.map((e) => e.toJson()).toList(),
  };
}
