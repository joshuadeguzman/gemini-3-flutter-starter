import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../services/habit_service.dart';
import 'widgets/summary_card.dart';
import 'widgets/habit_card.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/router/app_router.dart';

/// The main screen showing today's habits.
class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitService = context.watch<HabitService>();
    final habits = habitService.habits;
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMMM d').format(now);

    final hour = now.hour;
    final greeting = switch (hour) {
      < 12 => 'Good morning',
      < 17 => 'Good afternoon',
      _ => 'Good evening',
    };

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(dateStr, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      body: habits.isEmpty
          ? _buildEmptyState(context)
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
              children: [
                const SizedBox(height: AppSpacing.s8),
                const SummaryCard(),
                const SizedBox(height: AppSpacing.s24),
                Text(
                  'Today\'s Habits',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                ...habits.map(
                  (habit) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                    child: HabitCard(habit: habit),
                  ),
                ),
                const SizedBox(height: AppSpacing.s80), // Space for FAB
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRouter.addHabit),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(
              'No habits yet',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              'Start your journey by creating your first habit.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRouter.addHabit),
              icon: const Icon(Icons.add),
              label: const Text('Create your first habit'),
            ),
          ],
        ),
      ),
    );
  }
}
