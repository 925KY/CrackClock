import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Four bars plus the level in words, so the result never relies on colour alone.
class StrengthMeter extends StatelessWidget {
  final String level;
  final String label;
  final int bars;
  final String patternSummary;

  const StrengthMeter({
    super.key,
    required this.level,
    required this.label,
    required this.bars,
    required this.patternSummary,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forLevel(level);
    final words = patternSummary.isEmpty ? label : '$label · $patternSummary';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 10,
                margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                decoration: BoxDecoration(
                  color: i < bars ? color : AppColors.emptyBar,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Text(
          words,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textForLevel(level),
          ),
        ),
      ],
    );
  }
}
