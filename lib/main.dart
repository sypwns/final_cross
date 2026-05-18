import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/app_view_model.dart';
import 'views/splash_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const SmartStudyPlannerApp());
}

class SmartStudyPlannerApp extends StatelessWidget {
  const SmartStudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppViewModel>(
      create: (_) {
        final viewModel = AppViewModel();
        viewModel.init();
        return viewModel;
      },
      child: Consumer<AppViewModel>(
        builder: (context, viewModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Smart Study Planner',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: viewModel.isDark ? ThemeMode.dark : ThemeMode.light,
           home: const SplashScreen(),
          );
        },
      ),
    );
  }
}