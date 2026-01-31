import 'package:bizreh_admin/features/gifts/controllers/gifts_controller.dart';
import 'package:bizreh_admin/features/gifts/models/gifts_model.dart';
import 'package:bizreh_admin/features/gifts/views/user_gifts_view.dart';
import 'package:bizreh_admin/features/gifts/views/widgets/gift_form_dialog.dart';
import 'package:bizreh_admin/features/gifts/views/widgets/gifts_data_table.dart';
import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GiftsView extends StatelessWidget {
  const GiftsView({super.key});

  @override
  Widget build(BuildContext context) {
    final GiftsController controller = Get.put(GiftsController());
    final MainNavController nav = Get.find<MainNavController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search gifts...',
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(controller),
          onRefresh: controller.getGifts,
          addText: 'Add Gift',
          refreshText: 'Refresh',
          extraActions: [
            OutlinedButton.icon(
              onPressed: () {
                nav.push(
                  const MainNavEntry(
                    title: 'User Gifts',
                    page: UserGiftsView(),
                  ),
                );
              },
              icon: const Icon(Icons.card_giftcard_outlined),
              label: const Text('User Gifts'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = controller.filteredGifts;

          return GiftsDataTable(
            rows: rows,
            onEdit: (g) => _openEditDialog(controller, g),
            onDelete: (g) => _confirmDelete(controller, g),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(GiftsController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => GiftFormDialog(controller: controller),
    );
  }

  void _openEditDialog(GiftsController controller, GiftsModel gift) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setGiftForEdit(gift),
      dialogBuilder: (_) => GiftFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    GiftsController controller,
    GiftsModel gift,
  ) async {
    final id = gift.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Gift',
      message: 'Are you sure you want to delete "${gift.title ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteGift(id);
  }
}
