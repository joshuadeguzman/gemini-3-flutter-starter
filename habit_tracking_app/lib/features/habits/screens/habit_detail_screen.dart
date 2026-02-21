import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';
import 'add_habit_screen.dart';
import '../../../app/theme/app_spacing.dart';

/// Screen showing detailed stats for a specific habit.
class HabitDetailScreen extends StatelessWidget {
  final String habitId;

  const HabitDetailScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context) {
    final habitService = context.watch<HabitService>();
    final habit = habitService.habits.firstWhere((h) => h.id == habitId);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddHabitScreen(habit: habit),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        children: [
          _buildHeader(context, habit),
          const SizedBox(height: AppSpacing.s32),
          _buildStatsRow(context, habit),
          const SizedBox(height: AppSpacing.s32),
          _buildCalendarSection(context, habit),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Habit habit) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: habit.color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(habit.icon, size: 40, color: habit.color),
        ),
        const SizedBox(height: AppSpacing.s16),
        Text(
          habit.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (habit.description != null && habit.description!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
            child: Text(
              habit.description!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.s12),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s4,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            habit.frequency.name.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, Habit habit) {
    final showTarget = habit.targetCount != null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Current Streak',
                '${habit.currentStreak}',
                '🔥 days',
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: _buildStatCard(
                context,
                'Best Streak',
                '${habit.bestStreak}',
                '🏆 days',
              ),
            ),
          ],
        ),
        if (showTarget) ...[
          const SizedBox(height: AppSpacing.s12),
          _buildStatCard(
            context,
            'Daily Goal',
            '${habit.targetCount}',
            habit.unit ?? 'times',
            isLong: true,
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String unit, {
    bool isLong = false,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.s4),
                Text(
                  unit,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection(BuildContext context, Habit habit) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final weekdayOffset = firstDayOfMonth.weekday % 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Month',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.s12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: AppSpacing.s4,
                crossAxisSpacing: AppSpacing.s4,
              ),
              itemCount: daysInMonth + weekdayOffset,
              itemBuilder: (context, index) {
                if (index < weekdayOffset) return const SizedBox();
                final dayNum = index - weekdayOffset + 1;
                final date = DateTime(now.year, now.month, dayNum);
                final isCompleted = habit.completedDates.any(
                  (d) =>
                      d.year == date.year &&
                      d.month == date.month &&
                      d.day == date.day,
                );
                final isToday =
                    date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day;

                return Container(
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? habit.color
                        : Theme.of(context).colorScheme.surfaceContainerHighest
                              .withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: isToday
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNum',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isCompleted
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: isToday ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
