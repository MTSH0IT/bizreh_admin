import 'package:bizreh_admin/features/payment/controllers/payment_controller.dart';
import 'package:bizreh_admin/features/payment/models/payment_model.dart';
import 'package:bizreh_admin/features/payment/views/widgets/payment_form_dialog.dart';
import 'package:bizreh_admin/features/payment/views/widgets/payments_data_table.dart';
import 'package:bizreh_admin/features/payment/views/user_payments_report_by_year_view.dart';
import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search payments...',
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(controller),
          onRefresh: controller.getPayments,
          addText: 'Add Payment',
          refreshText: 'Refresh',
          extraActions: [
            ElevatedButton.icon(
              onPressed: () => _openUserReportByYear(context),
              icon: const Icon(Icons.assessment_outlined),
              label: const Text('Custom Report'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = controller.filteredPayments;

          return PaymentsDataTable(
            rows: rows,
            onEdit: (payment) => _openEditDialog(context, controller, payment),
            onDelete: (payment) => _confirmDelete(context, controller, payment),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(PaymentController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => PaymentFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    PaymentController controller,
    PaymentModel payment,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setPaymentForEdit(payment),
      dialogBuilder: (_) => PaymentFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    PaymentController controller,
    PaymentModel payment,
  ) async {
    final id = payment.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Payment',
      message:
          'Are you sure you want to delete this payment of ${payment.amount ?? '-'}?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deletePayment(id);
  }

  void _openUserReportByYear(BuildContext context) {
    final MainNavController nav = Get.find<MainNavController>();
    nav.push(
      const MainNavEntry(
        title: 'User Report by Year',
        page: UserPaymentsReportByYearView(),
      ),
    );
  }
}
