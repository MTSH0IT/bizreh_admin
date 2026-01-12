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

  ({int? id, int? price, int? stock, int? colorId, String? colorDegree}) _cell(
    Option option,
    int packagingId,
  ) {
    final list = option.packagingOptions;
    if (list == null || list.isEmpty) {
      return (
        id: null,
        price: null,
        stock: null,
        colorId: null,
        colorDegree: null,
      );
    }

    for (final p in list) {
      if (p.packagingId == packagingId) {
        return (
          id: p.id,
          price: p.pricePerUnit,
          stock: p.stockQuantity,
          colorId: p.color?.id,
          colorDegree: p.color?.degree,
        );
      }
    }

    return (
      id: null,
      price: null,
      stock: null,
      colorId: null,
      colorDegree: null,
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

                  final result = _cell(opt, id);

                  return DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: ${result.price?.toString() ?? '-'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Stock: ${result.stock?.toString() ?? '-'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF374151),
                          ),
                        ),
                        if (result.colorDegree != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: ColorDot(
                              size: 18,
                              color: parseColorDegree(result.colorDegree!),
                              selected: false,
                            ),
                          ),
                      ],
                    ),
                    onTap: onCellTap == null
                        ? null
                        : () => onCellTap!(
                            opt,
                            pkg,
                            result.id,
                            result.price,
                            result.stock,
                            result.colorId,
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
