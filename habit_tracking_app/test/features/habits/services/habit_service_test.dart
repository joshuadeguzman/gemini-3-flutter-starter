import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracking_app/features/habits/services/habit_service.dart';
import 'package:habit_tracking_app/features/habits/models/habit.dart';
import 'package:flutter/material.dart';

void main() {
  group('HabitService', () {
    late HabitService habitService;

    setUp(() {
      habitService = HabitService();
    });

    test('initial state has seed data', () {
      expect(habitService.habits.length, 4);
      expect(habitService.habits.any((h) => h.name == 'Exercise'), true);
    });

    test('addHabit adds a new habit', () {
      final habit = Habit(
        id: '',
        name: 'Test Habit',
        icon: Icons.abc,
        color: Colors.red,
      );
      habitService.addHabit(habit);
      expect(habitService.habits.length, 5);
      expect(habitService.habits.last.name, 'Test Habit');
      expect(habitService.habits.last.id, isNotEmpty);
    });

    test('toggleHabitCompletion updates completion status', () {
      final habitId = habitService.habits.first.id;
      final initialCompletion = habitService.habits.first.isCompletedToday;

      habitService.toggleHabitCompletion(habitId);
      expect(habitService.habits.first.isCompletedToday, !initialCompletion);

      habitService.toggleHabitCompletion(habitId);
      expect(habitService.habits.first.isCompletedToday, initialCompletion);
    });

    test('deleteHabit removes the habit', () {
      final habitId = habitService.habits.first.id;
      habitService.deleteHabit(habitId);
      expect(habitService.habits.length, 3);
      expect(habitService.habits.any((h) => h.id == habitId), false);
    });
  });
}
