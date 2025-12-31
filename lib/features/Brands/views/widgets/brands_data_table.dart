import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:flutter/material.dart';

class BrandsDataTable extends StatelessWidget {
  final List<BrandsModel> rows;
  final ValueChanged<BrandsModel>? onEdit;
  final ValueChanged<BrandsModel>? onDelete;

  const BrandsDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //   return Container(
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       border: Border.all(color: const Color(0xFFE5E7EB)),
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(12),
    //       child: SingleChildScrollView(
    //         scrollDirection: Axis.horizontal,
    //         child: DataTable(
    //           headingRowHeight: 52,
    //           dataRowMinHeight: 60,
    //           dataRowMaxHeight: 72,
    //           columns: const [
    //             DataColumn(label: Text('Image')),
    //             DataColumn(label: Text('Title')),
    //             DataColumn(label: Text('Arabic Title')),
    //             DataColumn(label: Text('Position')),
    //             DataColumn(label: Text('Products')),
    //             DataColumn(label: Text('Created At')),
    //             DataColumn(label: Text('Actions')),
    //           ],
    //           rows: rows.map((r) {
    //             return DataRow(
    //               cells: [
    //                 DataCell(_ImageCell(image: r.image)),
    //                 DataCell(Text(r.title ?? '-')),
    //                 DataCell(Text(r.arTitle ?? '-')),
    //                 DataCell(Text((r.position ?? 0).toString())),
    //                 DataCell(Text((r.productsCount ?? 0).toString())),
    //                 DataCell(
    //                   Text(
    //                     _formatDate(r.createdAt),
    //                     style: theme.textTheme.bodySmall?.copyWith(
    //                       color: const Color(0xFF6B7280),
    //                     ),
    //                   ),
    //                 ),
    //                 DataCell(
    //                   Row(
    //                     children: [
    //                       TextButton(
    //                         onPressed: onEdit == null ? null : () => onEdit!(r),
    //                         child: const Text('Edit'),
    //                       ),
    //                       const SizedBox(width: 8),
    //                       TextButton(
    //                         onPressed: onDelete == null
    //                             ? null
    //                             : () => onDelete!(r),
    //                         child: const Text('Delete'),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             );
    //           }).toList(),
    //         ),
    //       ),
    //     ),
    //   );
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
            columns: const [
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Title')),
              DataColumn(label: Text('Arabic Title')),
              DataColumn(label: Text('Position')),
              DataColumn(label: Text('Products')),
              DataColumn(label: Text('Created At')),
              DataColumn(label: Text('Actions')),
            ],
            rows: rows.map((r) {
              return DataRow(
                cells: [
                  DataCell(_ImageCell(image: r.image)),
                  DataCell(Text(r.title ?? '-')),
                  DataCell(Text(r.arTitle ?? '-')),
                  DataCell(Text((r.position ?? 0).toString())),
                  DataCell(Text((r.productsCount ?? 0).toString())),
                  DataCell(
                    Text(
                      _formatDate(r.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        TextButton(
                          onPressed: onEdit == null ? null : () => onEdit!(r),
                          child: const Text('Edit'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: onDelete == null
                              ? null
                              : () => onDelete!(r),
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

  static String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)}';
  }
}

class _ImageCell extends StatelessWidget {
  final String? image;

  const _ImageCell({required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 54,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: image == null || image!.isEmpty
            ? const ColoredBox(
                color: Color(0xFFF3F4F6),
                child: Icon(Icons.image_not_supported),
              )
            : ImageNetwork(image: image!),
      ),
    );
  }
}
