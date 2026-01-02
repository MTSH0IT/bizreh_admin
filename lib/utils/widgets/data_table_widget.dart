import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:flutter/material.dart';

// Generic data table widget that can be used for any entity
class DataTableWidget<T> extends StatelessWidget {
  final List<T> rows;
  final List<DataColumn> columns;
  final List<DataCell> Function(T item, int index) buildCells;
  final Function(T item)? onEdit;
  final Function(T item)? onDelete;
  final bool showActions;
  final String? emptyMessage;

  const DataTableWidget({
    super.key,
    required this.rows,
    required this.columns,
    required this.buildCells,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            emptyMessage ?? 'No data available',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 52,
            dataRowMinHeight: 60,
            dataRowMaxHeight: 72,
            columns: [
              ...columns,
              if (showActions && (onEdit != null || onDelete != null))
                const DataColumn(
                  label: Text(
                    'Actions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
            rows: rows.map((item) {
              final index = rows.indexOf(item);
              final cells = buildCells(item, index);

              return DataRow.byIndex(
                index: index,
                cells: [
                  ...cells,
                  if (showActions && (onEdit != null || onDelete != null))
                    DataCell(
                      Row(
                        children: [
                          if (onEdit != null)
                            TextButton(
                              onPressed: () => onEdit!(item),
                              child: const Text('Edit'),
                            ),
                          if (onEdit != null && onDelete != null)
                            const SizedBox(width: 8),
                          if (onDelete != null)
                            TextButton(
                              onPressed: () => onDelete!(item),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                        ],
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// Helper widget for displaying images in data tables
class DataTableImageCell extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;

  const DataTableImageCell({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final defaultSize = width ?? height ?? 54;

    return SizedBox(
      width: width ?? defaultSize,
      height: height ?? defaultSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageUrl == null || imageUrl!.isEmpty
            ? ColoredBox(
                color: const Color(0xFFF3F4F6),
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey[400],
                  size: (width ?? height ?? 54) * 0.5,
                ),
              )
            : ImageNetwork(image: imageUrl!),
      ),
    );
  }
}

// Helper widget for displaying dates in data tables
class DataTableDateCell extends StatelessWidget {
  final DateTime? date;
  final String? format;

  const DataTableDateCell({super.key, this.date, this.format});

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return const Text('-');
    }

    String formattedDate;
    if (format != null) {
      formattedDate = format!;
    } else {
      String two(int v) => v.toString().padLeft(2, '0');
      formattedDate = '${date!.year}-${two(date!.month)}-${two(date!.day)}';
    }

    return Text(
      formattedDate,
      style: const TextStyle(color: Color(0xFF6B7280)),
    );
  }
}

// Helper widget for displaying text with fallback
class DataTableTextCell extends StatelessWidget {
  final String? text;
  final String fallback;
  final TextStyle? style;

  const DataTableTextCell({
    super.key,
    this.text,
    this.fallback = '-',
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text?.isNotEmpty == true ? text! : fallback, style: style);
  }
}

// Helper widget for displaying numbers with fallback
class DataTableNumberCell extends StatelessWidget {
  final dynamic number;
  final String fallback;
  final TextStyle? style;

  const DataTableNumberCell({
    super.key,
    this.number,
    this.fallback = '-',
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(number?.toString() ?? fallback, style: style);
  }
}
