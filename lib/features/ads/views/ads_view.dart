import 'package:bizreh_admin/features/ads/controllers/ads_controller.dart';
import 'package:bizreh_admin/features/ads/models/ads_model.dart';
import 'package:bizreh_admin/features/ads/views/widgets/ads_data_table.dart';
import 'package:bizreh_admin/features/ads/views/widgets/ads_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdsView extends StatelessWidget {
  const AdsView({super.key});

  @override
  Widget build(BuildContext context) {
    final AdsController controller = Get.put(AdsController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search ads...',
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(controller),
          onRefresh: controller.getAds,
          addText: 'Add Ad',
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = controller.filteredAds;

          return AdsDataTable(
            rows: rows,
            isUpdatingStatus: controller.isUpdatingStatus,
            onToggleActive: (ad, isActive) {
              final id = ad.id;
              if (id == null) return;
              controller.changeStatus(adId: id, isActive: isActive);
            },
            onEdit: (ad) => _openEditDialog(controller, ad),
            onDelete: (ad) => _confirmDelete(controller, ad),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(AdsController controller) {
    openFormDialog<void>(
      onBeforeOpen: () {
        controller.clearForm();
        controller.getMeta();
      },
      dialogBuilder: (_) => AdsFormDialog(controller: controller),
    );
  }

  void _openEditDialog(AdsController controller, AdsModel ad) {
    openFormDialog<void>(
      onBeforeOpen: () {
        controller.setAdForEdit(ad);
        controller.getMeta();
      },
      dialogBuilder: (_) => AdsFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(AdsController controller, AdsModel ad) async {
    final id = ad.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Ad',
      message: 'Are you sure you want to delete "${ad.title ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteAd(id);
  }
}
