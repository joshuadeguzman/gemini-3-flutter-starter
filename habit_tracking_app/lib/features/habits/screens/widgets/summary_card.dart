import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/habit_service.dart';
import '../../../../app/theme/app_spacing.dart';

/// A card summarizing today's habit progress.
class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final habitService = context.watch<HabitService>();
    final habits = habitService.habits;
    final completedCount = habits.where((h) => h.isCompletedToday).length;
    final totalCount = habits.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Progress',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    '$completedCount of $totalCount habits completed',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withOpacity(0.1),
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
