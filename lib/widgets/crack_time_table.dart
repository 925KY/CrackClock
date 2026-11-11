import 'package:flutter/material.dart';

import '../models/analysis_result.dart';
import '../theme/app_colors.dart';

/// One row per attack speed: the attack, its guessing rate, and the time to crack.
class CrackTimeTable extends StatelessWidget {
  final List<CrackTime> times;

  const CrackTimeTable({super.key, required this.times});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          for (var i = 0; i < times.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.emptyBar),
            _row(times[i]),
          ],
        ],
      ),
    );
  }

  Widget _row(CrackTime t) {
    final instant = t.seconds < 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.label, style: const TextStyle(fontSize: 16, color: AppColors.text)),
                const SizedBox(height: 2),
                Text(t.rateText, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            t.display,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: instant ? AppColors.amber : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
