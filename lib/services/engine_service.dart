import 'package:flutter/services.dart';

import '../models/analysis_result.dart';

/// Talks to the Java engine (MainActivity.java) over the platform channel.
class EngineService {
  static const MethodChannel _channel = MethodChannel('com.crackclock/engine');

  /// Sends the password to Java and returns its analysis.
  /// Nothing is stored: the password lives only in memory while the app is open.
  Future<AnalysisResult> estimate(String password) async {
    final map = await _channel.invokeMapMethod<Object?, Object?>(
      'estimate',
      {'password': password},
    );
    if (map == null) {
      throw PlatformException(code: 'EMPTY', message: 'The engine returned nothing');
    }
    return AnalysisResult.fromMap(map);
  }
}
