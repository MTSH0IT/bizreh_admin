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
  final double? maxDataCellWidth;
  final double actionsCellMaxWidth;

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
    this.dataRowMinHeight = 70,
    this.dataRowMaxHeight = 75,
    this.columnSpacing = 8,
    this.horizontalMargin = 8,
    this.maxDataCellWidth,
    this.actionsCellMaxWidth = 140,
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
            final hasActions =
                showActions && (onEdit != null || onDelete != null);
            final totalColumns = columns.length + (hasActions ? 1 : 0);
            final inferredMaxCellWidth = totalColumns == 0
                ? constraints.maxWidth
                : (constraints.maxWidth / totalColumns);

            final cellMaxWidth =
                maxDataCellWidth ?? inferredMaxCellWidth.clamp(120, 420);

            DataCell constrainCell(DataCell cell, {double? maxWidth}) {
              final child = cell.child;
              return DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth ?? cellMaxWidth,
                  ),
                  child: Align(alignment: Alignment.centerLeft, child: child),
                ),
                placeholder: cell.placeholder,
                showEditIcon: cell.showEditIcon,
                onTap: cell.onTap,
                onLongPress: cell.onLongPress,
                onDoubleTap: cell.onDoubleTap,
                onTapCancel: cell.onTapCancel,
              );
            }

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
                    if (hasActions)
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
                    final constrainedCells = cells
                        .map((c) => constrainCell(c))
                        .toList();

                    return DataRow.byIndex(
                      index: index,
                      cells: [
                        ...constrainedCells,
                        if (hasActions)
                          constrainCell(
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
                            maxWidth: actionsCellMaxWidth,
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

  void _showImagePreview(BuildContext context, String url) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4.0,
                    child: ImageNetwork(
                      image: url,
                      icon: Icons.broken_image_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    Widget child = SizedBox(
      width: width ?? 54,
      height: height ?? 54,
      child: ImageNetwork(image: imageUrl ?? ''),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: hasImage ? () => _showImagePreview(context, imageUrl!) : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
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
  final int maxLines;

  const DataTableTextCell({
    super.key,
    this.text,
    this.fallback = '-',
    this.style,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text?.isNotEmpty == true ? text! : fallback,
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
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
