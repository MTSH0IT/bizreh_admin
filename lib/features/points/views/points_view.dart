import 'package:bizreh_admin/features/points/controllers/points_controller.dart';
import 'package:bizreh_admin/features/points/models/point_model.dart';
import 'package:bizreh_admin/features/points/views/widgets/point_form_dialog.dart';
import 'package:bizreh_admin/features/points/views/widgets/points_data_table.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointsView extends StatelessWidget {
  const PointsView({super.key});

  @override
  Widget build(BuildContext context) {
    final PointsController controller = Get.put(PointsController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search points offers...',
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(context, controller),
          onRefresh: controller.getPointsOffers,
          addText: 'Add Points Offer',
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = controller.filteredPointsOffers;

          return PointsDataTable(
            rows: rows,
            onEdit: (p) => _openEditDialog(context, controller, p),
            onDelete: (p) => _confirmDelete(context, controller, p),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(BuildContext context, PointsController controller) {
    openFormDialog<void>(
      onBeforeOpen: () {
        controller.clearForm;
        controller.getMeta();
      },

      dialogBuilder: (_) => PointFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    PointsController controller,
    PointModel point,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () {
        controller.setPointForEdit(point);
        controller.getMeta();
      },
      dialogBuilder: (_) => PointFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    PointsController controller,
    PointModel point,
  ) async {
    final id = point.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Points Offer',
      message: 'Are you sure you want to delete "${point.title ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deletePointsOffer(id);
  }
}
