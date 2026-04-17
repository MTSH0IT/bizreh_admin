import 'package:bizreh_admin/features/payment/models/user_payment_py_year/suggested_bonus.dart';
import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
import 'package:flutter/material.dart';

class SuggestedBonusCard extends StatelessWidget {
  final SuggestedBonus? suggestedBonus;

  const SuggestedBonusCard({super.key, required this.suggestedBonus});

  @override
  Widget build(BuildContext context) {
    if (suggestedBonus == null) {
      return const DetailsSectionCard(
        title: 'Suggested Bonus',
        child: Text('No bonus suggestion available', style: TextStyle(color: Colors.grey)),
      );
    }

    return DetailsSectionCard(
      title: 'Suggested Bonus',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_up_outlined,
                  size: 18,
                  color: Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Percentage',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${suggestedBonus!.percentage ?? 0}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFD97706),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Calculated Amount',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    suggestedBonus!.calculatedAmount ?? '-',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (suggestedBonus!.note != null && suggestedBonus!.note!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Note',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    suggestedBonus!.note!,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
