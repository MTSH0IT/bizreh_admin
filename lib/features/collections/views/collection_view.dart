import 'package:bizreh_admin/features/collections/controllers/collections_controller.dart';
import 'package:bizreh_admin/features/collections/models/collection_model/collection_model.dart';
import 'package:bizreh_admin/features/collections/views/widgets/collection_form_dialog.dart';
import 'package:bizreh_admin/features/collections/views/widgets/collection_products_section.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollectionView extends StatelessWidget {
  const CollectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionsController controller = Get.put(CollectionsController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search collections...',
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onRefresh: controller.getCollections,
          refreshText: 'Refresh',
          extraActions: [
            OutlinedButton.icon(
              onPressed: () => _openCreateDialog(controller),
              icon: const Icon(Icons.account_tree_outlined),
              label: const Text('Add Parent Collection'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final roots = controller.filteredCollections;
          if (roots.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Text(
                'No collections found',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            );
          }

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: roots
                  .map(
                    (model) => _CollectionModelTile(
                      model: model,
                      depth: 0,
                      onCreateChild: (id) =>
                          _openCreateDialog(controller, parentId: id),
                      onEdit: (m) => _openEditDialog(controller, m),
                      onDelete: (m) => _confirmDelete(controller, m),
                    ),
                  )
                  .toList(),
            ),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(
    CollectionsController controller, {
    int? parentId,
  }) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setForCreateParent(parentId: parentId),
      dialogBuilder: (_) => CollectionFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    CollectionsController controller,
    CollectionModel model,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setForEdit(model),
      dialogBuilder: (_) => CollectionFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    CollectionsController controller,
    CollectionModel model,
  ) async {
    final id = model.id;
    if (id == null) return;

    final title = model.title?.trim().isNotEmpty == true
        ? model.title!
        : (model.arTitle ?? '-');

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Collection',
      message: 'Are you sure you want to delete "$title"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteCollection(id);
  }
}

class _CollectionModelTile extends StatefulWidget {
  final CollectionModel model;
  final int depth;
  final void Function(int? parentId) onCreateChild;
  final void Function(CollectionModel model) onEdit;
  final void Function(CollectionModel model) onDelete;

  const _CollectionModelTile({
    required this.model,
    required this.depth,
    required this.onCreateChild,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_CollectionModelTile> createState() => _CollectionModelTileState();
}

class _CollectionModelTileState extends State<_CollectionModelTile> {
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
    final productsCount = model.productsCount ?? products.length;
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
                    '${_formatNumber(productsCount)} Items',
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
                    (child) => _CollectionModelTile(
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
              child: CollectionProductsSection(products: products),
            ),
        ],
      ),
    );
  }

  List<dynamic> _resolveProducts(CollectionModel model) {
    final direct = model.products;
    if (direct != null && direct.isNotEmpty) return direct;

    final ids = model.productIds;
    if (ids != null && ids.isNotEmpty) {
      return ids
          .map(
            (id) => <String, dynamic>{
              'id': id,
              'title': 'Product #$id',
            },
          )
          .toList();
    }

    final custom = model.customProductsArray;
    if (custom != null && custom.isNotEmpty) {
      return custom
          .map(
            (id) => <String, dynamic>{
              'id': id,
              'title': 'Product #$id',
            },
          )
          .toList();
    }

    if ((model.productsCount ?? 0) > 0) {
      return <Map<String, dynamic>>[
        <String, dynamic>{
          'title': '${model.productsCount} products available',
        },
      ];
    }

    return const <dynamic>[];
  }

  String _formatNumber(int value) {
    final text = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final indexFromEnd = text.length - i;
      buffer.write(text[i]);
      if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
        buffer.write(',');
      }
    }
    return buffer.toString();
  }
}

class _CollectionImage extends StatelessWidget {
  final String? image;

  const _CollectionImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        color: const Color(0xFFF8FAFC),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: (image != null && image!.trim().isNotEmpty)
            ? ImageNetwork(image: image!)
            : const Icon(
                Icons.collections_bookmark_outlined,
                size: 18,
                color: Color(0xFF64748B),
              ),
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
