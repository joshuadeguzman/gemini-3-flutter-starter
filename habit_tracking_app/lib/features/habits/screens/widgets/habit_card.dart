import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/habit.dart';
import '../../services/habit_service.dart';
import '../../../../app/theme/app_spacing.dart';

/// A tactile card representing a single habit.
class HabitCard extends StatefulWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.habit.isCompletedToday;
    final color = isCompleted
        ? widget.habit.color.withOpacity(0.5)
        : widget.habit.color;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () => context.push('/habit/${widget.habit.id}'),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          child: InkWell(
            onTap: () {
              // Same as above or keep separate for navigation/completion
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s12),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.habit.icon, color: color),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.habit.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isCompleted
                                    ? Theme.of(context).colorScheme.outline
                                    : null,
                              ),
                        ),
                        Text(
                          '🔥 ${widget.habit.currentStreak} day streak',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ),
                  _AnimatedCheckButton(
                    isCompleted: isCompleted,
                    onToggle: () {
                      context.read<HabitService>().toggleHabitCompletion(
                        widget.habit.id,
                      );
                    },
                    activeColor: widget.habit.color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedCheckButton extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onToggle;
  final Color activeColor;

  const _AnimatedCheckButton({
    required this.isCompleted,
    required this.onToggle,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggle,
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(AppSpacing.s4),
        decoration: BoxDecoration(
          color: isCompleted ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
                ? activeColor
                : Theme.of(context).colorScheme.outlineVariant,
            width: 2,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isCompleted ? Icons.check : null,
            key: ValueKey(isCompleted),
            size: 20,
            color: isCompleted ? Colors.white : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
