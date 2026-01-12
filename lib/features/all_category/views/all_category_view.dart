import 'package:bizreh_admin/features/all_category/controllers/all_category_controller.dart';
import 'package:bizreh_admin/features/all_category/views/widgets/all_category_data_table.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCategoryView extends StatelessWidget {
  const AllCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final AllCategoryController controller = Get.put(AllCategoryController());

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchField(
            hintText: 'Search categories...',
            onChanged: controller.setSearchQuery,
          ),
          const SizedBox(height: 12),
          ToolbarRow(
            onRefresh: controller.getAllCategories,
            refreshText: 'Refresh',
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const BuildProgressIndicator();
            }

            final rows = controller.filteredAllCategories;

            return AllCategoryDataTable(rows: rows);
          }),
        ],
      ),
    );
  }
}
