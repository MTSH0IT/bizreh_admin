import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/features/products/models/product_model/option.dart';
import 'package:bizreh_admin/utils/func/color_degree.dart';
import 'package:bizreh_admin/utils/widgets/color_dot.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class OptionsPackagingMatrixTable extends StatelessWidget {
  final List<Option> options;
  final List<PackageModel> packagings;
  final void Function(
    Option option,
    PackageModel packaging,
    int? mappingId,
    int? price,
    int? stock,
    int? colorId,
  )?
  onCellTap;

  const OptionsPackagingMatrixTable({
    super.key,
    required this.options,
    required this.packagings,
    this.onCellTap,
  });

  List<({int? id, int? price, int? stock, int? colorId, String? colorDegree})>
  _cells(Option option, int packagingId) {
    final list = option.packagingOptions;
    if (list == null || list.isEmpty) return const [];

    final results =
        <
          ({int? id, int? price, int? stock, int? colorId, String? colorDegree})
        >[];

    for (final p in list) {
      if (p.packagingId == packagingId) {
        results.add((
          id: p.id,
          price: p.pricePerUnit,
          stock: p.stockQuantity,
          colorId: p.color?.id,
          colorDegree: p.color?.degree,
        ));
      }
    }

    return results;
  }

  Widget _buildAddAction(Option opt, PackageModel pkg) {
    return InkWell(
      onTap: onCellTap == null
          ? null
          : () => onCellTap!(opt, pkg, null, null, null, null),
      child: const Padding(
        padding: EdgeInsets.only(top: 6),
        child: Text(
          'Add',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMappingRow(
    Option opt,
    PackageModel pkg,
    ({int? id, int? price, int? stock, int? colorId, String? colorDegree})
    mapping,
  ) {
    final dot = mapping.colorDegree == null
        ? Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(999),
            ),
          )
        : ColorDot(
            size: 16,
            color: parseColorDegree(mapping.colorDegree!),
            selected: false,
          );

    return InkWell(
      onTap: onCellTap == null
          ? null
          : () => onCellTap!(
              opt,
              pkg,
              mapping.id,
              mapping.price,
              mapping.stock,
              mapping.colorId,
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            dot,
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'P:${mapping.price?.toString() ?? '-'}  S:${mapping.stock?.toString() ?? '-'}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty || packagings.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'No options or packagings available',
            style: TextStyle(color: Colors.grey),
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
          child: DataTableWidget<Option>(
            rows: options,
            showActions: false,
            emptyMessage: 'No options or packagings available',
            dataRowMinHeight: 72,
            dataRowMaxHeight: 100,
            columns: [
              const DataColumn(
                label: Text(
                  'op/pk',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...packagings.map((p) {
                return DataColumn(
                  label: Text(
                    p.title ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }),
            ],
            buildCells: (opt, index) {
              return [
                DataCell(
                  Text(
                    opt.optionName ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                ...packagings.map((pkg) {
                  final id = pkg.id;
                  if (id == null) {
                    return const DataCell(Text('-'));
                  }

                  final results = _cells(opt, id);

                  return DataCell(
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (results.isEmpty)
                          const Text(
                            '-',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          )
                        else
                          ...results.map((m) => _buildMappingRow(opt, pkg, m)),
                        if (onCellTap != null) _buildAddAction(opt, pkg),
                      ],
                    ),
                  );
                }),
              ];
            },
          ),
        ),
      ),
    );
  }
}
