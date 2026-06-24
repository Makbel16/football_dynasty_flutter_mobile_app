import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class FootballDynastyApp extends StatelessWidget {
  const FootballDynastyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '${AppConstants.appName}: ${AppConstants.appSubtitle}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
