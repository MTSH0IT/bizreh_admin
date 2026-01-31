import 'package:bizreh_admin/features/gifts/models/user_gifts_model/user_gifts_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class UserGiftsDataTable extends StatelessWidget {
  final List<UserGiftsModel> rows;
  final void Function(UserGiftsModel model, String newStatus)? onChangeStatus;

  const UserGiftsDataTable({
    super.key,
    required this.rows,
    this.onChangeStatus,
  });

  static const _statuses = ['pending', 'redeemed', 'expired'];

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<UserGiftsModel>(
      rows: rows,
      emptyMessage: 'No user gifts found',
      showActions: false,
      columns: const [
        DataColumn(
          label: Text('Gift', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('User', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('email', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Created At',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Change Status',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      buildCells: (g, index) {
        final giftTitle = g.gift?.title ?? '-';
        final user = g.user;
        final userName =
            user?.fullName ??
            '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
        final email = user?.email ?? '-';
        final phone = user?.phone ?? '-';

        return [
          DataCell(
            Row(
              children: [
                DataTableImageCell(
                  imageUrl: g.gift?.image,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 8),
                Expanded(child: DataTableTextCell(text: giftTitle)),
              ],
            ),
          ),
          DataCell(DataTableTextCell(text: userName)),
          DataCell(DataTableTextCell(text: email)),
          DataCell(DataTableTextCell(text: phone)),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              // decoration: BoxDecoration(
              //   color: _statusColor(g.userGiftStatus).withValues(alpha: 0.1),
              //   borderRadius: BorderRadius.circular(12),
              // ),
              child: Text(
                g.userGiftStatus ?? '-',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _statusColor(g.userGiftStatus),
                ),
              ),
            ),
          ),
          DataCell(DataTableDateCell(date: g.createdAt)),
          DataCell(
            DropdownButton<String>(
              value: _normalizeStatus(g.userGiftStatus),
              items: _statuses
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: onChangeStatus == null
                  ? null
                  : (value) {
                      if (value == null) return;
                      onChangeStatus!(g, value);
                    },
            ),
          ),
        ];
      },
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.blue;
      case 'redeemed':
        return Colors.green;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _normalizeStatus(String? status) {
    if (_statuses.contains(status)) return status!;
    return 'pending';
  }
}
