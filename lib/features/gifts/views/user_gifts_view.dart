import 'package:bizreh_admin/features/gifts/controllers/user_gifts_controller.dart';
import 'package:bizreh_admin/features/gifts/views/widgets/user_gifts_data_table.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/status_filter_dropdown.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserGiftsView extends StatelessWidget {
  const UserGiftsView({super.key});

  static const List<String> _statusOptions = <String>[
    'all',
    'pending',
    'redeemed',
    'expired',
  ];

  @override
  Widget build(BuildContext context) {
    final UserGiftsController controller = Get.find<UserGiftsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SearchField(
              hintText: 'Search by gift or user...',
              onChanged: controller.setSearchQuery,
              initialValue: controller.searchQuery.value,
            ),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onRefresh: controller.getUserGifts,
          refreshText: 'Refresh',
          extraActions: [
            Obx(() {
              final value = controller.selectedStatus.value;
              final safeValue = _statusOptions.contains(value)
                  ? value
                  : 'pending';
              return StatusFilterDropdown(
                maxWidth: 220,
                value: safeValue,
                items: _statusOptions
                    .map(
                      (s) => DropdownMenuItem<String>(value: s, child: Text(s)),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  controller.setStatusFilter(v);
                },
              );
            }),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = controller.filteredUserGifts;

          return UserGiftsDataTable(
            rows: rows,
            onChangeStatus: (model, status) async {
              await controller.changeStatus(model: model, status: status);
            },
          );
        }),
      ],
    );
  }
}
