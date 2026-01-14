import 'package:bizreh_admin/features/discounts/controllers/discounts_controller.dart';
import 'package:bizreh_admin/features/discounts/models/discount_model/discount_model.dart';
import 'package:bizreh_admin/features/discounts/views/widgets/discount_form_dialog.dart';
import 'package:bizreh_admin/features/discounts/views/widgets/discounts_data_table.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountsView extends StatelessWidget {
  const DiscountsView({super.key});

  @override
  Widget build(BuildContext context) {
    final DiscountsController controller = Get.put(DiscountsController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search discounts...',
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(context, controller),
          onRefresh: controller.getDiscounts,
          addText: 'Add Discount',
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = controller.filteredDiscounts;

          return DiscountsDataTable(
            rows: rows,
            onEdit: (d) => _openEditDialog(context, controller, d),
            onDelete: (d) => _confirmDelete(context, controller, d),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(BuildContext context, DiscountsController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => DiscountFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    DiscountsController controller,
    DiscountModel discount,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setDiscountForEdit(discount),
      dialogBuilder: (_) => DiscountFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    DiscountsController controller,
    DiscountModel discount,
  ) async {
    final id = discount.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Discount',
      message: 'Are you sure you want to delete "${discount.title ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteDiscount(id);
  }
}
