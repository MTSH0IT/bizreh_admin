import 'package:bizreh_admin/features/collections/controllers/collections_controller.dart';
import 'package:bizreh_admin/features/collections/models/collection_model/collection_model.dart';
import 'package:bizreh_admin/features/collections/views/widgets/collection_form_dialog.dart';
import 'package:bizreh_admin/features/collections/views/widgets/collection_tile.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
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
          initialValue: controller.searchQuery.value,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onRefresh: controller.getCollections,
          refreshText: 'Refresh',
          extraActions: [
            OutlinedButton.icon(
              onPressed: () => _openCreateDialog(controller),
              icon: const Icon(Icons.account_tree_outlined),
              label: const Text('Add Collection'),
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
                    (model) => CollectionTile(
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

  void _openCreateDialog(CollectionsController controller, {int? parentId}) {
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
