import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/features/products/models/product_model/option.dart';
import 'package:bizreh_admin/features/option_packaging/views/widgets/option_packaging_matrix_cell.dart';
import 'package:bizreh_admin/features/option_packaging/views/widgets/option_packaging_mapping_types.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class OptionsPackagingMatrixTable extends StatelessWidget {
  final List<Option> options;
  final List<PackageModel> packagings;
  final void Function(
    Option option,
    PackageModel packaging,
    int? mappingId,
    num? price,
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

  List<OptionPackagingMapping> _cells(Option option, int packagingId) {
    final list = option.packagingOptions;
    if (list == null || list.isEmpty) return const [];

    final results = <OptionPackagingMapping>[];

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

    return DataTableWidget<Option>(
      rows: options,
      showActions: false,
      emptyMessage: 'No options or packagings available',
      dataRowMinHeight: 72,
      dataRowMaxHeight: 100,
      columns: [
        const DataColumn(
          label: Text('op/pk', style: TextStyle(fontWeight: FontWeight.bold)),
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
            return DataCell(
              OptionPackagingMatrixCell(
                option: opt,
                packaging: pkg,
                mappings: _cells(opt, id),
                onCellTap: onCellTap,
              ),
            );
          }),
        ];
      },
    );
  }
}
