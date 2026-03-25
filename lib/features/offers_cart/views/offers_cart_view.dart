import 'package:bizreh_admin/features/offers_cart/controllers/offers_cart_controller.dart';
import 'package:bizreh_admin/features/offers_cart/models/offers_cart_model.dart';
import 'package:bizreh_admin/features/offers_cart/views/widgets/offers_cart_data_table.dart';
import 'package:bizreh_admin/features/offers_cart/views/widgets/offers_cart_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OffersCartView extends StatelessWidget {
  const OffersCartView({super.key});

  @override
  Widget build(BuildContext context) {
    final OffersCartController controller = Get.put(OffersCartController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search offers...',
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(context, controller),
          onRefresh: controller.getOffers,
          addText: 'Add Offer',
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = controller.filteredOffers;

          return OffersCartDataTable(
            rows: rows,
            isUpdatingStatus: controller.isToggling,
            onEdit: (o) => _openEditDialog(context, controller, o),
            onDelete: (o) => _confirmDelete(context, controller, o),
            onToggle: (o) {
              final id = o.id;
              if (id == null) return;
              controller.toggleStatus(id, currentIsActive: o.isActive ?? 0);
            },
          );
        }),
      ],
    );
  }

  void _openCreateDialog(
    BuildContext context,
    OffersCartController controller,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () {
        controller.clearForm();
        controller.getMeta();
      },
      dialogBuilder: (_) => OffersCartFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    OffersCartController controller,
    OffersCartModel offer,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () {
        controller.setOfferForEdit(offer);
        controller.getMeta();
      },
      dialogBuilder: (_) => OffersCartFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    OffersCartController controller,
    OffersCartModel offer,
  ) async {
    final id = offer.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Offer',
      message: 'Are you sure you want to delete "${offer.name ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteOffer(id);
  }
}
