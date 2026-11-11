import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The big entropy number with the length and character pool under it.
class EntropyDisplay extends StatelessWidget {
  final double bits;
  final double rawBits;
  final int length;
  final int poolSize;
  final bool penalised;

  const EntropyDisplay({
    super.key,
    required this.bits,
    required this.rawBits,
    required this.length,
    required this.poolSize,
    required this.penalised,
  });

  @override
  Widget build(BuildContext context) {
    final details = StringBuffer(
      '$length character${length == 1 ? '' : 's'} · pool of $poolSize',
    );
    if (penalised) {
      details.write(' · ${rawBits.toStringAsFixed(0)} bits raw, cut for patterns');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${bits.toStringAsFixed(1)} bits',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          details.toString(),
          style: const TextStyle(fontSize: 15, color: AppColors.muted),
        ),
      ],
    );
  }
}
