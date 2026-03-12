import 'dart:ui';

import 'package:bizreh_admin/utils/consts/colors.dart';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:bizreh_admin/utils/func/date_format.dart';
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
  final double headingRowHeight;
  final double dataRowMinHeight;
  final double dataRowMaxHeight;
  final double columnSpacing;
  final double horizontalMargin;

  const DataTableWidget({
    super.key,
    required this.rows,
    required this.columns,
    required this.buildCells,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
    this.emptyMessage,
    this.headingRowHeight = 52,
    this.dataRowMinHeight = 55,
    this.dataRowMaxHeight = 70,
    this.columnSpacing = 8,
    this.horizontalMargin = 8,
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowHeight: headingRowHeight,
                  dataRowMinHeight: dataRowMinHeight,
                  dataRowMaxHeight: dataRowMaxHeight,
                  columnSpacing: columnSpacing,
                  horizontalMargin: horizontalMargin,
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
                  rows: rows.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final cells = buildCells(item, index);

                    return DataRow.byIndex(
                      index: index,
                      cells: [
                        ...cells,
                        if (showActions && (onEdit != null || onDelete != null))
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (onEdit != null)
                                  IconButton(
                                    onPressed: () => onEdit!(item),
                                    icon: const Icon(Icons.edit, size: 16),
                                    color: kprimaryColor,
                                    tooltip: 'Edit',
                                  ),
                                if (onDelete != null)
                                  IconButton(
                                    onPressed: () => onDelete!(item),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 16,
                                    ),
                                    color: Colors.red,
                                    tooltip: 'Delete',
                                  ),
                              ],
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
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
      child: ImageNetwork(image: imageUrl ?? ''),
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
    String formattedDate;
    if (format != null) {
      formattedDate = format!;
    } else {
      formattedDate = formatDate(date);
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
    return Text(
      text?.isNotEmpty == true ? text! : fallback,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
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
    return Text(
      number?.toString() ?? fallback,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
  }
}
