import 'package:bizreh_admin/features/discounts/models/discount_model/discount_model.dart';
import 'package:bizreh_admin/utils/func/date_format.dart';
import 'package:bizreh_admin/utils/widgets/details_key_value.dart';
import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
import 'package:flutter/material.dart';

class DiscountDetailsView extends StatelessWidget {
  final DiscountModel discount;

  const DiscountDetailsView({super.key, required this.discount});

  @override
  Widget build(BuildContext context) {
    // final title = (discount.title ?? '-').trim();
    // final arTitle = (discount.arTitle ?? '-').trim();

    final products = discount.products ?? const [];
    final brands = discount.brands ?? const [];
    final categories = discount.categories ?? const [];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 860;

        final summaryCard = DetailsSectionCard(
          title: 'Summary',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DetailsKeyValue(
                      label: 'Amount',
                      value: discount.amount?.toString() ?? '-',
                    ),
                  ),
                  Expanded(
                    child: DetailsKeyValue(
                      label: 'Amount Type',
                      value: (discount.amountType ?? '-').toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DetailsKeyValue(
                      label: 'Min Purchase',
                      value: discount.minPurchaseAmount?.toString() ?? '-',
                    ),
                  ),
                  Expanded(
                    child: DetailsKeyValue(
                      label: 'Min Quantity',
                      value: discount.minQuantity?.toString() ?? '-',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        final statusCard = DetailsSectionCard(
          title: 'Status & Dates',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DetailsKeyValue(
                      label: 'Active',
                      value: (discount.isActive ?? 0) == 1 ? 'Yes' : 'No',
                    ),
                  ),
                  Expanded(
                    child: DetailsKeyValue(
                      label: 'Expires',
                      value: formatDate(discount.expirationDate),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DetailsKeyValue(
                      label: 'Created',
                      value: formatDate(discount.createdAt),
                    ),
                  ),
                  Expanded(
                    child: DetailsKeyValue(
                      label: 'ID',
                      value: discount.id?.toString() ?? '-',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: summaryCard),
                  const SizedBox(width: 12),
                  Expanded(child: statusCard),
                ],
              )
            else
              Column(
                children: [summaryCard, const SizedBox(height: 12), statusCard],
              ),
            const SizedBox(height: 12),
            DetailsSectionCard(
              title: 'Targets',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TargetsRow(
                    label: 'Products',
                    count: discount.productsCount,
                    child: _ChipList(
                      items: products
                          .map(
                            (p) => (p.title?.isNotEmpty == true)
                                ? p.title!
                                : (p.arTitle ?? '-'),
                          )
                          .toList(),
                      emptyText: 'No products',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TargetsRow(
                    label: 'Brands',
                    count: discount.brandsCount,
                    child: _ChipList(
                      items: brands
                          .map(
                            (b) => (b.title?.isNotEmpty == true)
                                ? b.title!
                                : (b.arTitle ?? '-'),
                          )
                          .toList(),
                      emptyText: 'No brands',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TargetsRow(
                    label: 'Categories',
                    count: discount.categoriesCount,
                    child: _ChipList(
                      items: categories
                          .map(
                            (c) => (c.categoryTitle?.isNotEmpty == true)
                                ? c.categoryTitle!
                                : (c.categoryArTitle ?? '-'),
                          )
                          .toList(),
                      emptyText: 'No categories',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TargetsRow extends StatelessWidget {
  final String label;
  final int? count;
  final Widget child;

  const _TargetsRow({
    required this.label,
    required this.count,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              (count ?? 0).toString(),
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ChipList extends StatelessWidget {
  final List<String> items;
  final String emptyText;

  const _ChipList({required this.items, required this.emptyText});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(emptyText, style: const TextStyle(color: Color(0xFF6B7280)));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .where((e) => e.trim().isNotEmpty)
          .map(
            (t) => Chip(
              label: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: Text(t, overflow: TextOverflow.ellipsis),
              ),
              backgroundColor: const Color(0xFFF3F4F6),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          )
          .toList(),
    );
  }
}
