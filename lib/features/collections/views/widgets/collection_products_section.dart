import 'package:flutter/material.dart';

class CollectionProductsSection extends StatefulWidget {
  final List<dynamic> products;
  final int initialVisibleCount;

  const CollectionProductsSection({
    super.key,
    required this.products,
    this.initialVisibleCount = 6,
  });

  @override
  State<CollectionProductsSection> createState() =>
      _CollectionProductsSectionState();
}

class _CollectionProductsSectionState extends State<CollectionProductsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final items = widget.products.map(_toProductItem).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    final hasMore = items.length > widget.initialVisibleCount;
    final visibleItems = _expanded || !hasMore
        ? items
        : items.take(widget.initialVisibleCount).toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 14,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Products',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  '${items.length} Items',
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...visibleItems.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key == visibleItems.length - 1 ? 0 : 8,
              ),
              child: _ProductTile(item: entry.value),
            ),
          ),
          if (hasMore) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _expanded = !_expanded),
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                ),
                label: Text(_expanded ? 'Show less' : 'Show more'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _ProductItem _toProductItem(dynamic product) {
    if (product is Map<String, dynamic>) {
      final title = product['title']?.toString().trim() ?? '';
      final arTitle = product['ar_title']?.toString().trim() ?? '';
      final id = product['id']?.toString().trim() ?? '';
      final brand = product['brand_name']?.toString().trim() ?? '';
      final category = product['category_name']?.toString().trim() ?? '';
      final image = product['image']?.toString().trim() ?? '';

      final effectiveTitle = title.isNotEmpty
          ? title
          : arTitle.isNotEmpty
          ? arTitle
          : id.isNotEmpty
          ? 'Product #$id'
          : '-';

      final subtitleParts = <String>[
        if (brand.isNotEmpty) brand,
        if (category.isNotEmpty) category,
      ];

      return _ProductItem(
        title: effectiveTitle,
        subtitle: subtitleParts.join(' | '),
        id: id,
        image: image,
      );
    }

    final value = product?.toString().trim() ?? '';
    return _ProductItem(
      title: value.isEmpty ? '-' : value,
      subtitle: '',
      id: '',
      image: '',
    );
  }
}

class _ProductTile extends StatelessWidget {
  final _ProductItem item;

  const _ProductTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          _ProductThumb(image: item.image),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                if (item.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (item.id.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                '#${item.id}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductThumb extends StatelessWidget {
  final String image;

  const _ProductThumb({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: image.isNotEmpty
          ? Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.shopping_bag_outlined,
                size: 14,
                color: Color(0xFF64748B),
              ),
            )
          : const Icon(
              Icons.shopping_bag_outlined,
              size: 14,
              color: Color(0xFF64748B),
            ),
    );
  }
}

class _ProductItem {
  final String title;
  final String subtitle;
  final String id;
  final String image;

  const _ProductItem({
    required this.title,
    required this.subtitle,
    required this.id,
    required this.image,
  });
}
