import 'package:bizreh_admin/features/payment/controllers/user_reports_controller.dart';
import 'package:bizreh_admin/features/payment/views/widgets/user_report_by_year_table.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPaymentsReportByYearView extends StatefulWidget {
  const UserPaymentsReportByYearView({super.key});

  @override
  State<UserPaymentsReportByYearView> createState() =>
      _UserPaymentsReportByYearViewState();
}

class _UserPaymentsReportByYearViewState
    extends State<UserPaymentsReportByYearView> {
  late final String tag;
  late final UserReportsController controller;
  int? currentYear;

  @override
  void initState() {
    super.initState();
    tag = 'user_reports_${DateTime.now().millisecondsSinceEpoch}';
    controller = Get.put(UserReportsController(), tag: tag);

    // Initialize with current year
    currentYear = DateTime.now().year;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUserReportsByYear(currentYear!);
    });
  }

  @override
  void dispose() {
    Get.delete<UserReportsController>(tag: tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search reports...',
          onChanged: controller.setUserReportSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onRefresh: () => controller.getUserReportsByYear(currentYear!),
          addText: null,
          refreshText: 'Refresh',
          extraActions: [
            Text(
              'Year: ${currentYear ?? 'N/A'}',
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _selectYear,
              icon: const Icon(Icons.date_range_outlined),
              label: const Text('Change Year'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.isLoadingUserReports.value) {
            return const BuildProgressIndicator();
          }

          final reports = controller.filteredUserReports;

          if (reports.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.assessment_outlined,
                    color: Color(0xFF6B7280),
                    size: 48,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No reports found for the specified year',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            );
          }

          return UserReportByYearTable(reports: reports);
        }),
      ],
    );
  }

  Future<void> _selectYear() async {
    final now = DateTime.now();
    final startYear = now.year - 5;
    final endYear = now.year + 1;

    final selectedYear = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Year'),
        content: SizedBox(
          width: 200,
          height: 300,
          child: ListView.builder(
            itemCount: endYear - startYear + 1,
            itemBuilder: (context, index) {
              final year = startYear + index;
              final isSelected = year == (currentYear ?? now.year);
              return ListTile(
                title: Text(
                  year.toString(),
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? Theme.of(context).primaryColor : null,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(year);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedYear != null) {
      controller.getUserReportsByYear(selectedYear);
    }
  }
}
