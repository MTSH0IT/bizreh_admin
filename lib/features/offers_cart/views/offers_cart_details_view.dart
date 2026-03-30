import 'package:bizreh_admin/features/offers_cart/models/offers_cart_model/item.dart';
import 'package:bizreh_admin/features/offers_cart/models/offers_cart_model/offers_cart_model.dart';
import 'package:bizreh_admin/utils/func/date_format.dart';
import 'package:bizreh_admin/utils/widgets/details_key_value.dart';
import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:flutter/material.dart';

class OffersCartDetailsView extends StatelessWidget {
  final OffersCartModel offer;

  const OffersCartDetailsView({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final items = offer.items ?? const <Item>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(offer: offer),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;

            final left = Column(
              children: [
                _SummaryCard(offer: offer),
                const SizedBox(height: 12),
                _DescriptionCard(offer: offer),
              ],
            );

            final right = Column(children: [_StatusCard(offer: offer)]);

            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: left),
                  const SizedBox(width: 12),
                  Expanded(child: right),
                ],
              );
            }

            return Column(children: [left, const SizedBox(height: 12), right]);
          },
        ),
        const SizedBox(height: 12),
        _ItemsCard(items: items),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final OffersCartModel offer;

  const _Header({required this.offer});

  @override
  Widget build(BuildContext context) {
    final title = (offer.name ?? offer.arName ?? 'Offer').trim();
    final status = (offer.isActive ?? 0) == 1 ? 'Active' : 'Inactive';
    final statusColor = (offer.isActive ?? 0) == 1
        ? const Color(0xFF059669)
        : const Color(0xFF6B7280);

    return DetailsSectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? 'Offer' : title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Created: ${formatDate(offer.createdAt)}',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _Badge(label: status, color: statusColor),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final OffersCartModel offer;

  const _SummaryCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Summary',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'Price',
                  value: offer.price ?? '-',
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'Quantity',
                  value: offer.quantity?.toString() ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'Items count',
                  value: offer.itemsCount?.toString() ?? '-',
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'Calculated total',
                  value: offer.calculatedTotal?.toString() ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'Savings',
                  value: offer.savings?.toString() ?? '-',
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'ID',
                  value: offer.id?.toString() ?? '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final OffersCartModel offer;

  const _DescriptionCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Description',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsKeyValue(
            label: 'English',
            value: (offer.description ?? '-').trim().isEmpty
                ? '-'
                : offer.description!,
          ),
          const SizedBox(height: 8),
          DetailsKeyValue(
            label: 'Arabic',
            value: (offer.arDescription ?? '-').trim().isEmpty
                ? '-'
                : offer.arDescription!,
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final OffersCartModel offer;

  const _StatusCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Status & Dates',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'Active',
                  value: (offer.isActive ?? 0) == 1 ? 'Yes' : 'No',
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'Updated',
                  value: formatDate(offer.updatedAt),
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
                  value: formatDate(offer.createdAt),
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'Name (AR)',
                  value: offer.arName ?? '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final List<Item> items;

  const _ItemsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Items',
      child: items.isEmpty
          ? const Text('No items', style: TextStyle(color: Color(0xFF6B7280)))
          : Column(
              children: [
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ItemTile(item: item),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final Item item;

  const _ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final title = (item.product?.arTitle ?? item.product?.title ?? '-').trim();
    final option =
        (item.productOption?.arName ?? item.productOption?.name ?? '-').trim();
    final packaging = (item.packaging?.arTitle ?? item.packaging?.title ?? '-')
        .trim();
    final brand =
        (item.product?.brand?.arTitle ?? item.product?.brand?.title ?? '-')
            .trim();
    final category =
        (item.product?.category?.arTitle ??
                item.product?.category?.title ??
                '-')
            .trim();
    final supCategory =
        (item.product?.subCategory?.arTitle ??
                item.product?.subCategory?.title ??
                '-')
            .trim();
    final image = item.productOption?.mainImage ?? item.product?.image ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ImageNetwork(image: image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? '-' : title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _InlineMeta(
                      label: 'SKU',
                      value: item.packaging?.sku ?? '-',
                    ),
                    _InlineMeta(label: 'Option', value: option),
                    _InlineMeta(label: 'Packaging', value: packaging),
                    _InlineMeta(
                      label: 'Qty',
                      value: item.quantity?.toString() ?? '-',
                    ),
                    _InlineMeta(
                      label: 'Stock Qty',
                      value: item.stockQuantity?.toString() ?? '-',
                    ),
                    _InlineMeta(
                      label: 'Brand',
                      value: brand.isEmpty ? '-' : brand,
                    ),
                    _InlineMeta(
                      label: 'Category',
                      value: category.isEmpty ? '-' : category,
                    ),
                    _InlineMeta(
                      label: 'Sub-category',
                      value: supCategory.isEmpty ? '-' : supCategory,
                    ),
                    if (item.color != null)
                      _InlineMeta(
                        label: 'Color',
                        value: item.color?.arName ?? item.color?.name ?? '-',
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.totalPrice?.toString() ?? '-',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                item.pricePerUnit == null ? '-' : 'Unit: ${item.pricePerUnit}',
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineMeta extends StatelessWidget {
  final String label;
  final String value;

  const _InlineMeta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7280),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: Text(
            value.isEmpty ? '-' : value,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}
