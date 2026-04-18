import 'package:bizreh_admin/features/payment/models/user_payment_py_year/user_payment_py_year.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class UserReportByYearTable extends StatelessWidget {
  final List<UserPaymentPyYear> reports;

  const UserReportByYearTable({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('No reports found', style: TextStyle(color: Colors.grey)),
        ),
      );
    }
    return DataTableWidget<UserPaymentPyYear>(
      rows: reports,
      emptyMessage: 'No reports match your search',
      showActions: false,
      columns: const [
        DataColumn(
          label: Text('User', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        // DataColumn(
        //   label: Text('Year', style: TextStyle(fontWeight: FontWeight.bold)),
        // ),
        DataColumn(
          label: Text(
            'Total Payments',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Total Bonus',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Orders Count',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Orders Total',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Suggested Bonus',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      buildCells: (report, index) {
        final userName = report.user?.name ?? '-';
        final userEmail = report.user?.email ?? '';
        //final year = report.summary?.year?.toString() ?? '-';
        final totalPayments = report.summary?.totalPayments?.toString() ?? '-';
        final totalBonus = report.summary?.totalBonus?.toString() ?? '-';
        final ordersCount = report.summary?.ordersCount?.toString() ?? '-';
        final ordersTotal = report.summary?.ordersTotal?.toString() ?? '-';
        final suggestedBonus =
            '${report.suggestedBonus?.percentage ?? 0}% (${report.suggestedBonus?.calculatedAmount ?? '-'})';

        return [
          DataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (userEmail.isNotEmpty)
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
              ],
            ),
          ),
          //DataCell(DataTableTextCell(text: year)),
          DataCell(DataTableTextCell(text: totalPayments)),
          DataCell(DataTableTextCell(text: totalBonus)),
          DataCell(DataTableTextCell(text: ordersCount)),
          DataCell(DataTableTextCell(text: ordersTotal)),
          DataCell(DataTableTextCell(text: suggestedBonus)),
        ];
      },
    );
  }
}
