import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../habits/services/habit_service.dart';
import '../../../app/theme/app_spacing.dart';

/// Screen showing overall habit statistics.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitService = context.watch<HabitService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        children: [
          _buildOverallStats(context, habitService),
          const SizedBox(height: AppSpacing.s32),
          _buildWeeklyChart(context, habitService),
        ],
      ),
    );
  }

  Widget _buildOverallStats(BuildContext context, HabitService service) {
    final habits = service.habits;
    final totalActive = habits.length;
    final totalCompletions = habits.fold<int>(
      0,
      (sum, h) => sum + h.completedDates.length,
    );
    final longestStreak = habits.fold<int>(0, (max, h) {
      final s = h.bestStreak;
      return s > max ? s : max;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.s12),
        Row(
          children: [
            Expanded(
              child: _buildSimpleStatCard(
                context,
                'Active Habits',
                '$totalActive',
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: _buildSimpleStatCard(
                context,
                'Total Done',
                '$totalCompletions',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        _buildSimpleStatCard(
          context,
          'Longest Streak of All Time',
          '$longestStreak 🔥',
        ),
      ],
    );
  }

  Widget _buildSimpleStatCard(
    BuildContext context,
    String title,
    String value,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, HabitService service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past 7 Days',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.s12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: SizedBox(
              height: 200,
              child: CustomPaint(
                painter: _WeeklyBarChartPainter(
                  data: _getWeeklyData(service),
                  color: Theme.of(context).colorScheme.primary,
                  onSurface: Theme.of(context).colorScheme.onSurface,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<int> _getWeeklyData(HabitService service) {
    final now = DateTime.now();
    final data = List<int>.filled(7, 0);
    for (int i = 0; i < 7; i++) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - i));
      data[i] = service.habits
          .where(
            (h) => h.completedDates.any(
              (d) =>
                  d.year == date.year &&
                  d.month == date.month &&
                  d.day == date.day,
            ),
          )
          .length;
    }
    return data;
  }
}

class _WeeklyBarChartPainter extends CustomPainter {
  final List<int> data;
  final Color color;
  final Color onSurface;

  _WeeklyBarChartPainter({
    required this.data,
    required this.color,
    required this.onSurface,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = data.fold<int>(1, (max, v) => v > max ? v : max).toDouble();
    final barWidth = size.width / (data.length * 2 - 1);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < data.length; i++) {
      final val = data[i].toDouble();
      final barHeight = (val / maxVal) * (size.height - 30);
      final x = i * barWidth * 2;
      final y = size.height - 20 - barHeight;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);

      // Draw value text
      textPainter.text = TextSpan(
        text: '${data[i]}',
        style: TextStyle(
          color: onSurface,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, y - 18),
      );

      // Draw day label
      final dayLabel = [
        'M',
        'T',
        'W',
        'T',
        'F',
        'S',
        'S',
      ][(DateTime.now().weekday - 7 + i) % 7];
      textPainter.text = TextSpan(
        text: dayLabel,
        style: TextStyle(color: onSurface.withOpacity(0.5), fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, size.height - 15),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
