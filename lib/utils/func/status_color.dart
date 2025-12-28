import 'package:flutter/material.dart';

Color getStatusColor(String statusLabel) {
  switch (statusLabel) {
    case 'Delivered':
      return const Color(0xFF16A34A);
    case 'Shipped':
      return const Color(0xFFF59E0B);
    case 'Processing':
    case 'pending':
      return const Color(0xFF2563EB);
    case 'canceled':
      return const Color(0xFFD81D10);
    default:
      return Colors.grey;
  }
}
