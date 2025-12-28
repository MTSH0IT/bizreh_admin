import 'package:flutter/material.dart';

Color parseColorDegree(dynamic degree) {
  if (degree == null) return Colors.white;
  if (degree is int) return Color(degree);
  if (degree is String) {
    final v = degree.trim();
    final normalized = v.startsWith('#') ? v.substring(1) : v;
    final hex = normalized.startsWith('0x')
        ? normalized.substring(2)
        : normalized;
    final value = int.tryParse(hex, radix: 16);
    if (value == null) return Colors.grey;
    if (hex.length <= 6) {
      return Color(0xFF000000 | value);
    }
    return Color(value);
  }
  return Colors.grey;
}
