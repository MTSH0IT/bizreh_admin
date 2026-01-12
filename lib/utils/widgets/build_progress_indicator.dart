import 'package:flutter/material.dart';

class BuildProgressIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final bool centered;

  const BuildProgressIndicator({
    super.key,
    this.size = 28,
    this.strokeWidth = 2.5,
    this.centered = true,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(strokeWidth: strokeWidth),
    );

    if (!centered) return indicator;
    return Center(child: indicator);
  }
}
