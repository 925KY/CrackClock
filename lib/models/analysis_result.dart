/// One row of the crack-time table, as sent by the Java engine.
class CrackTime {
  final String label;
  final double guessesPerSecond;
  final double seconds;
  final String display;

  const CrackTime({
    required this.label,
    required this.guessesPerSecond,
    required this.seconds,
    required this.display,
  });

  factory CrackTime.fromMap(Map<Object?, Object?> map) => CrackTime(
        label: map['label'] as String,
        guessesPerSecond: (map['guessesPerSecond'] as num).toDouble(),
        seconds: (map['seconds'] as num).toDouble(),
        display: map['display'] as String,
      );

  /// The attack speed in words, for example "100 guesses/hour".
  String get rateText {
    if (guessesPerSecond < 1) {
      return '${(guessesPerSecond * 3600).round()} guesses/hour';
    }
    if (guessesPerSecond >= 1e9) {
      return '${(guessesPerSecond / 1e9).round()} billion guesses/sec';
    }
    final whole = guessesPerSecond.round().toString();
    final grouped = whole.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]},',
    );
    return '$grouped guesses/sec';
  }
}

/// Everything the engine returns for one password.
class AnalysisResult {
  final int length;
  final int poolSize;
  final double rawBits;
  final double bits;
  final String level;
  final String levelLabel;
  final int bars;
  final String patternSummary;
  final List<CrackTime> crackTimes;
  final List<String> tips;

  const AnalysisResult({
    required this.length,
    required this.poolSize,
    required this.rawBits,
    required this.bits,
    required this.level,
    required this.levelLabel,
    required this.bars,
    required this.patternSummary,
    required this.crackTimes,
    required this.tips,
  });

  bool get isStrong => level == 'STRONG' || level == 'VERY_STRONG';

  /// True when pattern checks lowered the score by more than half a bit.
  bool get wasPenalised => rawBits - bits > 0.5;

  factory AnalysisResult.fromMap(Map<Object?, Object?> map) => AnalysisResult(
        length: (map['length'] as num).toInt(),
        poolSize: (map['poolSize'] as num).toInt(),
        rawBits: (map['rawBits'] as num).toDouble(),
        bits: (map['bits'] as num).toDouble(),
        level: map['level'] as String,
        levelLabel: map['levelLabel'] as String,
        bars: (map['bars'] as num).toInt(),
        patternSummary: (map['patternSummary'] as String?) ?? '',
        crackTimes: (map['crackTimes'] as List<Object?>)
            .map((row) => CrackTime.fromMap(row as Map<Object?, Object?>))
            .toList(),
        tips: List<String>.from(map['tips'] as List<Object?>),
      );
}
