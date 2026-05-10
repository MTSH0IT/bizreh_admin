import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  /// القيمة الأولية لحقل البحث — تُستخدم لاستعادة النص عند العودة من شاشة أخرى
  final String? initialValue;

  const SearchField({
    super.key,
    this.hintText,
    this.onChanged,
    this.controller,
    this.initialValue,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    // إذا لم يُمرَّر controller خارجي، ننشئ واحدًا داخليًا
    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.initialValue ?? '',
      );
    }
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // عند إعادة البناء، نتحقق إذا تغيرت initialValue ونحدّث الحقل
    if (widget.controller == null && oldWidget.controller == null) {
      final newInitial = widget.initialValue ?? '';
      if (_internalController.text != newInitial) {
        // نحافظ على موضع المؤشر
        final selection = _internalController.selection;
        _internalController.text = newInitial;
        if (selection.end <= newInitial.length) {
          _internalController.selection = selection;
        }
      }
    }
  }

  @override
  void dispose() {
    // نُتلف الـ controller الداخلي فقط (الخارجي يتولى صاحبه تنظيفه)
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: TextField(
        controller: _effectiveController,
        onChanged: widget.onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
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
      ),
    );
  }
}
