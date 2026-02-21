import 'package:flutter/material.dart';

/// Represents a user's habit.
class Habit {
  final String id;
  final String name;
  final String? description;
  final IconData icon;
  final Color color;
  final List<DateTime> completedDates;
  final HabitFrequency frequency;
  final int? targetCount;
  final String? unit;

  const Habit({
    required this.id,
    required this.name,
    this.description,
    required this.icon,
    required this.color,
    this.completedDates = const [],
    this.frequency = HabitFrequency.daily,
    this.targetCount,
    this.unit,
  });

  /// Returns true if the habit is completed today.
  bool get isCompletedToday {
    final now = DateTime.now();
    return completedDates.any(
      (d) => d.year == now.year && d.month == now.month && d.day == now.day,
    );
  }

  /// Calculates the current streak of completions.
  int get currentStreak {
    if (completedDates.isEmpty) return 0;

    final sortedDates = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // If not completed today or yesterday, streak is 0
    final lastCompletion = DateTime(
      sortedDates.first.year,
      sortedDates.first.month,
      sortedDates.first.day,
    );

    if (lastCompletion.isBefore(today.subtract(const Duration(days: 1))) &&
        !isCompletedToday) {
      return 0;
    }

    int streak = 0;
    DateTime checkDate = isCompletedToday
        ? today
        : today.subtract(const Duration(days: 1));

    for (final date in sortedDates) {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      if (normalizedDate == checkDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (normalizedDate.isBefore(checkDate)) {
        break;
      }
    }

    return streak;
  }

  /// Calculates the best streak of all time.
  int get bestStreak {
    if (completedDates.isEmpty) return 0;

    final sortedDates = List<DateTime>.from(completedDates)
      ..sort((a, b) => a.compareTo(b));

    int maxStreak = 0;
    int currentStreakCount = 0;
    DateTime? prevDate;

    for (final date in sortedDates) {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      if (prevDate == null) {
        currentStreakCount = 1;
      } else {
        final difference = normalizedDate.difference(prevDate).inDays;
        if (difference == 1) {
          currentStreakCount++;
        } else if (difference > 1) {
          currentStreakCount = 1;
        }
      }
      if (currentStreakCount > maxStreak) {
        maxStreak = currentStreakCount;
      }
      prevDate = normalizedDate;
    }

    return maxStreak;
  }

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    Color? color,
    List<DateTime>? completedDates,
    HabitFrequency? frequency,
    int? targetCount,
    String? unit,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      completedDates: completedDates ?? this.completedDates,
      frequency: frequency ?? this.frequency,
      targetCount: targetCount ?? this.targetCount,
      unit: unit ?? this.unit,
    );
  }
}

/// Frequency options for habits.
enum HabitFrequency { daily, weekdays, weekends, custom }
