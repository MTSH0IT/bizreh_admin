import 'package:bizreh_admin/features/cities/controllers/cities_controller.dart';
import 'package:bizreh_admin/features/cities/models/city_model.dart';
import 'package:bizreh_admin/features/cities/views/widgets/cities_data_table.dart';
import 'package:bizreh_admin/features/cities/views/widgets/city_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CitiesView extends StatelessWidget {
  const CitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final CitiesController controller = Get.put(CitiesController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search cities...',
          onChanged: controller.setSearchQuery,
          initialValue: controller.searchQuery.value,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(controller),
          onRefresh: controller.getCities,
          addText: 'Add City',
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = controller.filteredCities;

          return CitiesDataTable(
            rows: rows,
            onEdit: (c) => _openEditDialog(controller, c),
            onDelete: (c) => _confirmDelete(controller, c),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(CitiesController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => CityFormDialog(controller: controller),
    );
  }

  void _openEditDialog(CitiesController controller, CityModel city) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setCityForEdit(city),
      dialogBuilder: (_) => CityFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    CitiesController controller,
    CityModel city,
  ) async {
    final id = city.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete City',
      message: 'Are you sure you want to delete "${city.title ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteCity(id);
  }
}
