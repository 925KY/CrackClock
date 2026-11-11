import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/analysis_result.dart';
import '../services/engine_service.dart';
import '../theme/app_colors.dart';
import '../widgets/crack_time_table.dart';
import '../widgets/entropy_display.dart';
import '../widgets/strength_meter.dart';
import '../widgets/tips_list.dart';

/// The app's single page: password field, meter, entropy, crack times and tips.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _engine = EngineService();

  AnalysisResult? _result;
  String? _error;
  bool _obscure = true;
  int _requestId = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onChanged(String password) async {
    final id = ++_requestId;
    if (password.isEmpty) {
      setState(() {
        _result = null;
        _error = null;
      });
      return;
    }
    try {
      final result = await _engine.estimate(password);
      // Ignore answers to older keystrokes that arrive late.
      if (!mounted || id != _requestId) return;
      setState(() {
        _result = result;
        _error = null;
      });
    } on MissingPluginException {
      if (!mounted) return;
      setState(() => _error = 'The engine runs on Android only. Start the app on an Android phone or emulator.');
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Engine error: ${e.message}');
    }
  }

  void _clear() {
    _controller.clear();
    _onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    final borderColor =
        result == null ? AppColors.emptyBar : AppColors.forLevel(result.level);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Row(
              children: const [
                Text(
                  'CrackClock',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                Spacer(),
                Icon(Icons.lock_outline, color: AppColors.amber, size: 28),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              obscureText: _obscure,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.visiblePassword,
              onChanged: _onChanged,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 18,
                color: AppColors.text,
              ),
              decoration: InputDecoration(
                hintText: 'Type a password',
                hintStyle: const TextStyle(color: AppColors.muted),
                filled: true,
                fillColor: AppColors.field,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: borderColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: borderColor, width: 2),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        tooltip: 'Clear',
                        icon: const Icon(Icons.close, color: AppColors.muted),
                        onPressed: _clear,
                      ),
                    TextButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      child: Text(
                        _obscure ? 'Show' : 'Hide',
                        style: const TextStyle(color: AppColors.lightBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Checked on your phone only. Never stored or sent.',
              style: TextStyle(fontSize: 13, color: AppColors.muted),
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: AppColors.veryWeak, fontSize: 15))
            else if (result == null)
              const _EmptyState()
            else
              ..._results(result),
          ],
        ),
      ),
    );
  }

  List<Widget> _results(AnalysisResult r) => [
        StrengthMeter(
          level: r.level,
          label: r.levelLabel,
          bars: r.bars,
          patternSummary: r.patternSummary,
        ),
        const SizedBox(height: 24),
        EntropyDisplay(
          bits: r.bits,
          rawBits: r.rawBits,
          length: r.length,
          poolSize: r.poolSize,
          penalised: r.wasPenalised,
        ),
        const SizedBox(height: 28),
        const _SectionTitle('Time to crack'),
        CrackTimeTable(times: r.crackTimes),
        const SizedBox(height: 28),
        const _SectionTitle('Tips'),
        TipsList(tips: r.tips, strong: r.isStrong),
      ];
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.muted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'Start typing to see your password’s strength in bits, how long it '
        'would survive four kinds of attack, and how to make it stronger.',
        style: TextStyle(fontSize: 16, height: 1.4, color: AppColors.muted),
      ),
    );
  }
}
