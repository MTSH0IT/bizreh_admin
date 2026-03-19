import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/features/products/models/product_model/option.dart';
import 'package:bizreh_admin/features/option_packaging/views/widgets/option_packaging_mapping_types.dart';
import 'package:bizreh_admin/utils/func/color_degree.dart';
import 'package:bizreh_admin/utils/widgets/color_dot.dart';
import 'package:flutter/material.dart';

class OptionPackagingMappingRow extends StatelessWidget {
  final Option option;
  final PackageModel packaging;
  final OptionPackagingMapping mapping;
  final OptionPackagingTapCallback? onTap;

  const OptionPackagingMappingRow({
    super.key,
    required this.option,
    required this.packaging,
    required this.mapping,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
      onTap: onTap == null
          ? null
          : () => onTap!((
              option: option,
              packaging: packaging,
              mapping: mapping,
            )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            dot,
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'SKU:${mapping.optionSku ?? '-'}  P:${mapping.price?.toString() ?? '-'}  S:${mapping.stock?.toString() ?? '-'}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
