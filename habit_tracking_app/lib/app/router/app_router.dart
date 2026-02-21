import 'package:go_router/go_router.dart';
import '../main_screen.dart';
import '../../features/habits/screens/add_habit_screen.dart';
import '../../features/habits/screens/habit_detail_screen.dart';

// Screens will be imported here
// import '../../features/settings/screens/settings_screen.dart';

/// App routing configuration.
class AppRouter {
  static const String home = '/';
  static const String addHabit = '/add-habit';
  static const String habitDetail = '/habit/:id';

  static final router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(path: home, builder: (context, state) => const MainScreen()),
      GoRoute(
        path: addHabit,
        builder: (context, state) => const AddHabitScreen(),
      ),
      GoRoute(
        path: '/habit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return HabitDetailScreen(habitId: id);
        },
      ),
    ],
  );
}
