import 'package:bizreh_admin/features/SuperCategory/models/super_category_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:bizreh_admin/features/category/views/category_view.dart';
import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:get/get.dart';

class SuperCategoryDataTable extends StatelessWidget {
  final List<SuperCategoryModel> rows;
  final Function(SuperCategoryModel) onEdit;
  final Function(SuperCategoryModel) onDelete;

  const SuperCategoryDataTable({
    super.key,
    required this.rows,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<SuperCategoryModel>(
      rows: rows,
      emptyMessage: 'No super categories found',
      onEdit: onEdit,
      onDelete: onDelete,
      columns: const [
        DataColumn(
          label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Arabic Title',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Position',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Created At',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      buildCells: (superCategory, index) {
        return [
          DataCell(
            DataTableImageCell(
              imageUrl: superCategory.image,
              width: 50,
              height: 50,
              borderRadius: 8,
            ),
          ),
          DataCell(DataTableTextCell(text: superCategory.title)),
          DataCell(DataTableTextCell(text: superCategory.arTitle)),
          DataCell(DataTableNumberCell(number: superCategory.position)),
          DataCell(
            ElevatedButton.icon(
              onPressed: () {
                Get.find<MainNavController>().push(
                  MainNavEntry(
                    title: superCategory.title ?? 'Categories',
                    page: CategoryView(superCategoryId: superCategory.id),
                  ),
                );
              },
              icon: const Icon(Icons.category_outlined, size: 16),
              label: const Text('Categories'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
            ),
          ),
          DataCell(DataTableDateCell(date: superCategory.createdAt)),
        ];
      },
    );
  }
}
