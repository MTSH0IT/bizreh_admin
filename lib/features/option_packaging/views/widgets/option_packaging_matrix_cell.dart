import 'package:bizreh_admin/features/option_packaging/views/widgets/option_packaging_mapping_row.dart';
import 'package:bizreh_admin/features/option_packaging/views/widgets/option_packaging_mapping_types.dart';
import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/features/products/models/product_model/option.dart';
import 'package:bizreh_admin/utils/consts/colors.dart';
import 'package:flutter/material.dart';

class OptionPackagingMatrixCell extends StatelessWidget {
  final Option option;
  final PackageModel packaging;
  final List<OptionPackagingMapping> mappings;
  final void Function(
    Option option,
    PackageModel packaging,
    int? mappingId,
    int? price,
    int? stock,
    int? colorId,
  )?
  onCellTap;

  const OptionPackagingMatrixCell({
    super.key,
    required this.option,
    required this.packaging,
    required this.mappings,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mappings.isEmpty)
            const Text(
              '-',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            )
          else
            ...mappings.map(
              (m) => OptionPackagingMappingRow(
                option: option,
                packaging: packaging,
                mapping: m,
                onTap: onCellTap,
              ),
            ),
          if (onCellTap != null)
            InkWell(
              onTap: () =>
                  onCellTap!(option, packaging, null, null, null, null),
              child: const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 12,
                    color: kprimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
