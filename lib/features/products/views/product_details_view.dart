import 'package:bizreh_admin/features/products/models/product_model/option.dart';
import 'package:bizreh_admin/features/products/models/product_model/packaging_option.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/utils/func/date_format.dart';
import 'package:bizreh_admin/utils/widgets/details_key_value.dart';
import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final options = product.options ?? const <Option>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(product: product),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;

            final leftContent = Column(
              children: [
                _OverviewCard(product: product),
                const SizedBox(height: 12),
                _DescriptionCard(product: product),
              ],
            );

            final rightContent = Column(
              children: [
                _OrganizationCard(product: product),
                const SizedBox(height: 12),
                _TagsCard(product: product),
              ],
            );

            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: leftContent),
                  const SizedBox(width: 12),
                  Expanded(child: rightContent),
                ],
              );
            }

            return Column(
              children: [leftContent, const SizedBox(height: 12), rightContent],
            );
          },
        ),
        const SizedBox(height: 12),
        _OptionsCard(options: options),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ProductModel product;

  const _Header({required this.product});

  @override
  Widget build(BuildContext context) {
    final name = _pickFirst(
      product.title,
      product.arTitle,
      fallback: 'Product',
    );
    final id = product.id == null ? '' : ' #${product.id}';
    final active = (product.isActive ?? 0) == 1;

    return DetailsSectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 78,
              height: 78,
              child: ImageNetwork(image: product.image ?? ''),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name$id',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Created: ${formatDate(product.createdAt)}',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _Badge(
            label: active ? 'ACTIVE' : 'INACTIVE',
            color: active ? const Color(0xFF059669) : const Color(0xFF64748B),
          ),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final ProductModel product;

  const _OverviewCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Overview',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'ID',
                  value: product.id?.toString() ?? '-',
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'Position',
                  value: product.position?.toString() ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'Title',
                  value: product.title ?? '-',
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'Arabic title',
                  value: product.arTitle ?? '-',
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
  final ProductModel product;

  const _DescriptionCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Description',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsKeyValue(
            label: 'English description',
            value: product.description ?? '-',
          ),
          const SizedBox(height: 8),
          DetailsKeyValue(
            label: 'Arabic description',
            value: product.arDescription ?? '-',
          ),
        ],
      ),
    );
  }
}

class _OrganizationCard extends StatelessWidget {
  final ProductModel product;

  const _OrganizationCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Organization',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'Brand',
                  value: _pickFirst(
                    product.brandName,
                    product.arBrandName,
                    fallback: '-',
                  ),
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'Sub category',
                  value: _pickFirst(
                    product.subCategoryName,
                    product.arSubCategoryName,
                    fallback: '-',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'Brand ID',
                  value: product.brandId?.toString() ?? '-',
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'Sub category ID',
                  value: product.subCategoryId?.toString() ?? '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagsCard extends StatelessWidget {
  final ProductModel product;

  const _TagsCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final tags = product.tagsArray ?? const <String>[];

    return DetailsSectionCard(
      title: 'Tags',
      child: tags.isEmpty
          ? DetailsKeyValue(label: 'Tags', value: product.tags ?? '-')
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Text(
                        tag.trim().isEmpty ? '-' : tag,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D4ED8),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _OptionsCard extends StatelessWidget {
  final List<Option> options;

  const _OptionsCard({required this.options});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Options',
      child: options.isEmpty
          ? const Text('No options', style: TextStyle(color: Color(0xFF6B7280)))
          : Column(
              children: options
                  .map(
                    (option) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _OptionTile(option: option),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final Option option;

  const _OptionTile({required this.option});

  @override
  Widget build(BuildContext context) {
    final optionTitle = _pickFirst(
      option.optionName,
      option.arOptionName,
      fallback: '-',
    );
    final packs = option.packagingOptions ?? const <PackagingOption>[];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: ImageNetwork(image: option.mainImage ?? ''),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      optionTitle,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        _InlineMeta(
                          label: 'ID',
                          value: option.id?.toString() ?? '-',
                        ),
                        _InlineMeta(
                          label: 'Stock',
                          value: option.stockQuantity?.toString() ?? '-',
                        ),
                        _InlineMeta(
                          label: 'Created',
                          value: formatDate(option.createdAt),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (packs.isEmpty)
            const Text(
              'No packaging options',
              style: TextStyle(color: Color(0xFF6B7280)),
            )
          else
            Column(
              children: packs
                  .map(
                    (pack) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _PackagingRow(pack: pack),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _PackagingRow extends StatelessWidget {
  final PackagingOption pack;

  const _PackagingRow({required this.pack});

  @override
  Widget build(BuildContext context) {
    final title = _pickFirst(
      pack.packagingTitle,
      pack.arPackagingTitle,
      fallback: '-',
    );
    final colorTitle = _pickFirst(
      pack.color?.name,
      pack.color?.arName,
      fallback: '-',
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 6,
        children: [
          _InlineMeta(label: 'Packaging', value: title),
          _InlineMeta(label: 'SKU', value: pack.optionSku ?? '-'),
          _InlineMeta(
            label: 'Price',
            value: pack.pricePerUnit?.toString() ?? '-',
          ),
          _InlineMeta(
            label: 'Stock',
            value: pack.stockQuantity?.toString() ?? '-',
          ),
          _InlineMeta(label: 'Color', value: colorTitle),
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
          constraints: const BoxConstraints(maxWidth: 260),
          child: Text(
            value.trim().isEmpty ? '-' : value,
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

String _pickFirst(String? first, String? second, {required String fallback}) {
  final f = (first ?? '').trim();
  if (f.isNotEmpty) return f;

  final s = (second ?? '').trim();
  if (s.isNotEmpty) return s;

  return fallback;
}
