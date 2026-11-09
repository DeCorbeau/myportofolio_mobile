import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgMain,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accentPurple,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.accentPurple,
          secondary: AppColors.accentCyan,
          surface: AppColors.bgMain,
        ),
        fontFamily: 'SpaceGrotesk',
      ),
      home: MyHomePage(),
    );
  }
}