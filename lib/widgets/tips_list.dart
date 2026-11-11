import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The engine's tips, with a check mark when the password is already strong.
class TipsList extends StatelessWidget {
  final List<String> tips;
  final bool strong;

  const TipsList({super.key, required this.tips, required this.strong});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final tip in tips)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  strong ? Icons.check_circle_outline : Icons.lightbulb_outline,
                  size: 22,
                  color: strong ? AppColors.lightBlue : AppColors.amber,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(fontSize: 16, height: 1.35, color: AppColors.text),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
