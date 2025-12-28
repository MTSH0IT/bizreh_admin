import 'package:flutter/material.dart';

class BuildProgressIndicator extends StatelessWidget {
  const BuildProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const SizedBox(
        height: 28,
        width: 28,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      ),
    );
  }
}
