import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';

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
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 15,
                  color: Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Products',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Text(
                  '${items.length} Items',
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...visibleItems.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key == visibleItems.length - 1 ? 0 : 8,
              ),
              child: _ProductTile(item: entry.value),
            ),
          ),
          if (hasMore) ...[
            const SizedBox(height: 10),
            Center(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _expanded = !_expanded),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                ),
                label: Text(
                  _expanded ? 'Show less' : 'Show more',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _ProductItem _toProductItem(dynamic product) {
    if (product is ProductModel) {
      final title = (product.title ?? '').trim();
      final arTitle = (product.arTitle ?? '').trim();
      final id = product.id?.toString() ?? '';
      final brand = (product.brandName ?? product.arBrandName ?? '').trim();
      final category =
          (product.subCategoryName ?? product.arSubCategoryName ?? '').trim();
      return _ProductItem(
        title: title.isNotEmpty
            ? title
            : arTitle.isNotEmpty
            ? arTitle
            : (id.isNotEmpty ? 'Product #$id' : '-'),
        subtitle: [
          if (brand.isNotEmpty) brand,
          if (category.isNotEmpty) category,
        ].join(' | '),
        id: id,
        image: (product.image ?? '').trim(),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE3EE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          _ProductThumb(image: item.image),
          const SizedBox(width: 10),
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
                    fontSize: 13.5,
                  ),
                ),
                if (item.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.8,
                      color: Color(0xFF5B6B82),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (item.id.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Text(
                '#${item.id}',
                style: const TextStyle(
                  fontSize: 11.2,
                  color: Color(0xFF334155),
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
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ImageNetwork(image: image),
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
