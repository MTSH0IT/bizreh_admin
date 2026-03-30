import 'package:flutter/material.dart';

Color getOrderStatusColor(String statusLabel) {
  switch (statusLabel) {
    case 'delivered':
      return const Color(0xFF16A34A);
    case 'pending':
      return const Color(0xFF2563EB);
    case 'assigned_to_driver':
      return const Color(0xFFF59E0B);
    case 'failed':
      return const Color.fromARGB(255, 172, 17, 138);
    case 'cancelled':
      return const Color(0xFFD81D10);
    default:
      return Colors.grey;
  }
}

Color getGiftStatusColor(String statusLabel) {
  switch (statusLabel) {
    case 'pending':
      return const Color(0xFF2563EB);
    case 'redeemed':
      return const Color(0xFF16A34A);
    case 'expired':
      return const Color(0xFFDC2626);
    default:
      return Colors.grey;
  }
}

Color getPaymentStatusColor(String statusLabel) {
  switch (statusLabel) {
    case 'paid':
      return const Color(0xFF16A34A);
    case 'pending':
      return const Color(0xFF2563EB);
    case 'unpaid':
      return const Color(0xFFD81D10);
    case 'refunded':
      return const Color(0xFFF59E0B);
    default:
      return Colors.grey;
  }
}
