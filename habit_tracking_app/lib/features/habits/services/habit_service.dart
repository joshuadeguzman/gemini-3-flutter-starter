import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';

/// Service to manage habits in-memory using ChangeNotifier.
class HabitService extends ChangeNotifier {
  final List<Habit> _habits = [];
  final _uuid = const Uuid();

  List<Habit> get habits => List.unmodifiable(_habits);

  HabitService() {
    _seedData();
  }

  /// Seeds the app with initial data.
  void _seedData() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final twoDaysAgo = now.subtract(const Duration(days: 2));

    _habits.addAll([
      Habit(
        id: _uuid.v4(),
        name: 'Exercise',
        icon: Icons.fitness_center,
        color: Colors.orange,
        completedDates: [now, yesterday, twoDaysAgo],
      ),
      Habit(
        id: _uuid.v4(),
        name: 'Read',
        icon: Icons.menu_book,
        color: Colors.blue,
        completedDates: [yesterday, twoDaysAgo],
      ),
      Habit(
        id: _uuid.v4(),
        name: 'Meditate',
        icon: Icons.self_improvement,
        color: Colors.purple,
        completedDates: [now, twoDaysAgo],
      ),
      Habit(
        id: _uuid.v4(),
        name: 'Drink Water',
        icon: Icons.water_drop,
        color: Colors.cyan,
        completedDates: [now, yesterday],
      ),
    ]);
  }

  /// Adds a new habit.
  void addHabit(Habit habit) {
    _habits.add(habit.copyWith(id: _uuid.v4()));
    notifyListeners();
  }

  /// Updates an existing habit.
  void updateHabit(Habit habit) {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners();
    }
  }

  /// Deletes a habit.
  void deleteHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  /// Toggles completion status for today.
  void toggleHabitCompletion(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = _habits[index];
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final completedDates = List<DateTime>.from(habit.completedDates);
      final todayIndex = completedDates.indexWhere(
        (d) =>
            d.year == today.year &&
            d.month == today.month &&
            d.day == today.day,
      );

      if (todayIndex != -1) {
        completedDates.removeAt(todayIndex);
      } else {
        completedDates.add(now);
      }

      _habits[index] = habit.copyWith(completedDates: completedDates);
      notifyListeners();
    }
  }

  /// Returns overall completion rate for today as a double (0.0 to 1.0).
  double get todayCompletionRate {
    if (_habits.isEmpty) return 0.0;
    final completedCount = _habits.where((h) => h.isCompletedToday).length;
    return completedCount / _habits.length;
  }
}
