import 'package:bizreh_admin/features/payment/controllers/payment_controller.dart';
import 'package:bizreh_admin/features/payment/views/widgets/suggested_bonus_card.dart';
import 'package:bizreh_admin/features/payment/views/widgets/user_report_by_year_table.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPaymentsReportByYearView extends StatelessWidget {
  const UserPaymentsReportByYearView({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailsSectionCard(
          title: 'User Payment Report by Year',
          child: Row(
            children: [
              Expanded(
                child: LabeledTextField(
                  label: 'Year',
                  hint: 'Enter year (e.g., 2024)',
                  controller: controller.yearController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => controller.getUserReportsByYear(),
                icon: const Icon(Icons.search),
                label: const Text('Load Report'),
              ),
              const SizedBox(width: 8),
              Obx(() {
                if (controller.isLoadingUserReports.value) {
                  return const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                return IconButton(
                  onPressed: () => controller.getUserReportsByYear(),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.isLoadingUserReports.value) {
            return const BuildProgressIndicator();
          }

          final reports = controller.filteredUserReports;

          if (reports.isEmpty) {
            return _EmptyState(
              onRetry: controller.getUserReportsByYear,
            );
          }

          return Column(
            children: [
              // Show first suggested bonus if available
              if (reports.first.suggestedBonus != null) ...[
                SuggestedBonusCard(suggestedBonus: reports.first.suggestedBonus),
                const SizedBox(height: 12),
              ],
              // Reports table
              DetailsSectionCard(
                title: 'User Reports',
                child: UserReportByYearTable(
                  reports: reports,
                  searchQuery: controller.userReportSearchQuery.value.trim().isEmpty
                      ? null
                      : controller.userReportSearchQuery.value.trim(),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.assessment_outlined, color: Color(0xFF6B7280), size: 48),
          const SizedBox(height: 16),
          const Text(
            'No reports found for the specified year',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
