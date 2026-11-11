import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

void main() => runApp(const CrackClockApp());

class CrackClockApp extends StatelessWidget {
  const CrackClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CrackClock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
          brightness: Brightness.dark,
        ).copyWith(surface: AppColors.background),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const HomeScreen(),
    );
  }
}
