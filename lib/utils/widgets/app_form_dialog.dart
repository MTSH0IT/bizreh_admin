import 'package:flutter/material.dart';

class AppFormDialog extends StatelessWidget {
  final Widget title;
  final Widget child;
  final List<Widget> actions;
  final double width;
  final EdgeInsetsGeometry contentPadding;

  const AppFormDialog({
    super.key,
    required this.title,
    required this.child,
    required this.actions,
    this.width = 400,
    this.contentPadding = const EdgeInsets.fromLTRB(24, 20, 24, 24),
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      contentPadding: contentPadding,
      content: ConstrainedBox(
        constraints: BoxConstraints(minWidth: width, maxWidth: width),
        child: SingleChildScrollView(child: child),
      ),
      actions: actions,
    );
  }
}
