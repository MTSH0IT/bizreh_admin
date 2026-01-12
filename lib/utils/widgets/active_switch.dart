import 'package:flutter/material.dart';

class ActiveSwitch extends StatelessWidget {
  final bool value;
  final bool disabled;
  final ValueChanged<bool>? onChanged;

  const ActiveSwitch({
    super.key,
    required this.value,
    required this.disabled,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(value: value, onChanged: disabled ? null : onChanged);
  }
}
