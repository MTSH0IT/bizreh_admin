import 'package:bizreh_admin/features/collections/models/collection_model/collection_model.dart';
import 'package:bizreh_admin/features/collections/views/widgets/collection_products_section.dart';
import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/features/products/views/product_details_view.dart';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollectionTile extends StatefulWidget {
  final CollectionModel model;
  final int depth;
  final void Function(int? parentId) onCreateChild;
  final void Function(CollectionModel model) onEdit;
  final void Function(CollectionModel model) onDelete;

  const CollectionTile({
    super.key,
    required this.model,
    required this.depth,
    required this.onCreateChild,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<CollectionTile> createState() => _CollectionTileState();
}

class _CollectionTileState extends State<CollectionTile> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final children = model.subCollections ?? const <CollectionModel>[];
    final products = _resolveProducts(model);
    final hasChildren = children.isNotEmpty;
    final productsCount =
        model.totalProductsCount ?? model.productsCount ?? products.length;
    final hasProducts = products.isNotEmpty || productsCount > 0;
    final canExpand = hasChildren || hasProducts;
    final title = model.title?.trim().isNotEmpty == true
        ? model.title!
        : (model.arTitle ?? 'Collection #${model.id ?? '-'}');
    final collectionType = (model.type ?? '').trim().toLowerCase();
    final isProductsType = collectionType == 'products';
    final typeLabel = collectionType.isNotEmpty
        ? collectionType
        : 'collections';
    final isActive = model.status == 1;

    return Container(
      decoration: BoxDecoration(
        color: widget.depth == 0 ? Colors.white : const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(
            color: widget.depth == 0
                ? const Color(0xFFE5E7EB)
                : const Color(0xFFF3F7FA),
          ),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 10 + (widget.depth * 24.0),
                      end: 8,
                    ),
                    child: Row(
                      children: [
                        if (canExpand)
                          InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => setState(() => _expanded = !_expanded),
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: Icon(
                                _expanded
                                    ? Icons.keyboard_arrow_down_rounded
                                    : Icons.keyboard_arrow_right_rounded,
                                size: 18,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 22),
                        const SizedBox(width: 6),
                        _CollectionImage(image: model.image),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: widget.depth == 0
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  fontSize: 13.5,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${children.length} sub-collections',
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'type: $typeLabel',
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '$productsCount Items',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _StatusPill(isActive: isActive),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      if (!isProductsType)
                        _ActionIcon(
                          icon: Icons.add,
                          color: const Color(0xFF2563EB),
                          onTap: () => widget.onCreateChild(model.id),
                        ),
                      _ActionIcon(
                        icon: Icons.edit_outlined,
                        color: const Color(0xFF334155),
                        onTap: () => widget.onEdit(model),
                      ),
                      _ActionIcon(
                        icon: Icons.delete_outline,
                        color: const Color(0xFFDC2626),
                        onTap: () => widget.onDelete(model),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_expanded && hasChildren)
            Column(
              children: children
                  .map(
                    (child) => CollectionTile(
                      model: child,
                      depth: widget.depth + 1,
                      onCreateChild: widget.onCreateChild,
                      onEdit: widget.onEdit,
                      onDelete: widget.onDelete,
                    ),
                  )
                  .toList(),
            ),
          if (_expanded && hasProducts)
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 42 + (widget.depth * 24.0),
                end: 12,
                bottom: 10,
              ),
              child: CollectionProductsSection(
                products: products,
                onProductTap: _openProductDetails,
              ),
            ),
        ],
      ),
    );
  }

  void _openProductDetails(ProductModel product) {
    final title = (product.title ?? product.arTitle ?? '').trim();
    final id = product.id;

    Get.find<MainNavController>().push(
      MainNavEntry(
        title: title.isNotEmpty ? title : 'Product ${id ?? ''}',
        page: ProductDetailsView(product: product),
      ),
    );
  }

  List<dynamic> _resolveProducts(CollectionModel model) {
    final direct = model.products;
    if (direct != null && direct.isNotEmpty) return direct;

    final ids = model.productIds;
    if (ids != null && ids.isNotEmpty) {
      return ids
          .map((id) => <String, dynamic>{'id': id, 'title': 'Product #$id'})
          .toList();
    }

    final custom = model.customProductsArray;
    if (custom != null && custom.isNotEmpty) {
      return custom
          .map((id) => <String, dynamic>{'id': id, 'title': 'Product #$id'})
          .toList();
    }

    if ((model.productsCount ?? 0) > 0) {
      return <Map<String, dynamic>>[
        <String, dynamic>{'title': '${model.productsCount} products available'},
      ];
    }

    return const <dynamic>[];
  }
}

class _CollectionImage extends StatelessWidget {
  final String? image;

  const _CollectionImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        color: const Color(0xFFF8FAFC),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ImageNetwork(image: image ?? ""),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isActive;

  const _StatusPill({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD1FAE5) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 7,
            color: isActive ? const Color(0xFF10B981) : const Color(0xFF64748B),
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'ACTIVE' : 'INACTIVE',
            style: TextStyle(
              color: isActive
                  ? const Color(0xFF047857)
                  : const Color(0xFF475569),
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 26,
        height: 26,
        child: Icon(icon, size: 15, color: color),
      ),
    );
  }
}
