// import 'payment.dart';
// import 'summary.dart';

// class UserPaymentModel {
//   String? userId;
//   List<Payment>? payments;
//   Summary? summary;

//   UserPaymentModel({this.userId, this.payments, this.summary});

//   factory UserPaymentModel.fromJson(Map<String, dynamic> json) {
//     return UserPaymentModel(
//       userId: json['user_id'] as String?,
//       payments: (json['payments'] as List<dynamic>?)
//           ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       summary: json['summary'] == null
//           ? null
//           : Summary.fromJson(json['summary'] as Map<String, dynamic>),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'user_id': userId,
//     'payments': payments?.map((e) => e.toJson()).toList(),
//     'summary': summary?.toJson(),
//   };
// }
