import 'package:flutter/material.dart';

class StatusFilterDropdown extends StatelessWidget {
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?>? onChanged;
  final double maxWidth;

  const StatusFilterDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.maxWidth = 260,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: DropdownButtonFormField<String>(
        key: ValueKey<String>(value),
        initialValue: value,
        isDense: true,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.2),
          ),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
