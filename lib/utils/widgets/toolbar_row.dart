import 'package:flutter/material.dart';

class ToolbarRow extends StatelessWidget {
  final VoidCallback? onAdd;
  final VoidCallback? onRefresh;
  final String? addText;
  final String? refreshText;
  final IconData? addIcon;
  final IconData? refreshIcon;
  final List<Widget>? extraActions;

  const ToolbarRow({
    super.key,
    this.onAdd,
    this.onRefresh,
    this.addText,
    this.refreshText,
    this.addIcon,
    this.refreshIcon,
    this.extraActions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onAdd != null)
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: Icon(addIcon ?? Icons.add),
            label: Text(addText ?? 'Add'),
          ),
        if (onAdd != null && onRefresh != null) const SizedBox(width: 12),
        if (onRefresh != null)
          OutlinedButton.icon(
            onPressed: onRefresh,
            icon: Icon(refreshIcon ?? Icons.refresh),
            label: Text(refreshText ?? 'Refresh'),
          ),
        if (extraActions != null && extraActions!.isNotEmpty) ...[
          const SizedBox(width: 12),
          ...extraActions!,
        ],
      ],
    );
  }
}
