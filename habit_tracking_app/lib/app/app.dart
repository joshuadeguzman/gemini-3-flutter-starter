import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import '../features/habits/services/habit_service.dart';

/// The main application widget.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HabitService())],
      child: MaterialApp.router(
        title: 'Habit Tracking App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
