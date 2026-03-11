import 'package:bizreh_admin/features/points/models/user_points_balance_model.dart';
import 'package:bizreh_admin/services/points_service.dart';
import 'package:flutter/material.dart';

class UserPointsBalanceView extends StatelessWidget {
  final int userId;

  const UserPointsBalanceView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserPointsBalanceModel>(
      future: PointsService().getUserPointsBalance(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final data = snapshot.data;
        if (data == null) {
          return const Center(child: Text('No data'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'User Points Balance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    'User #${data.userId}',
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 860;

                final left = _SectionCard(
                  title: 'Balance',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _KeyValue(
                              label: 'Available Points',
                              value: data.availablePoints.toString(),
                            ),
                          ),
                          Expanded(
                            child: _KeyValue(
                              label: 'Transactions',
                              value: data.totalTransactions.toString(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );

                final right = _SectionCard(
                  title: 'Totals',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _KeyValue(
                              label: 'Total Earned',
                              value: data.totalPointsEarned.toString(),
                            ),
                          ),
                          Expanded(
                            child: _KeyValue(
                              label: 'Total Used',
                              value: data.totalPointsUsed.toString(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );

                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: left),
                      const SizedBox(width: 12),
                      Expanded(child: right),
                    ],
                  );
                }

                return Column(
                  children: [left, const SizedBox(height: 12), right],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _SectionCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  final String label;
  final String value;

  const _KeyValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.trim().isEmpty ? '-' : value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
