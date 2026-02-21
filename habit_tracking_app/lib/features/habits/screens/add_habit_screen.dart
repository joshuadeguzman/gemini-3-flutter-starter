import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_colors.dart';

/// Screen to create or edit a habit.
class AddHabitScreen extends StatefulWidget {
  final Habit? habit;

  const AddHabitScreen({super.key, this.habit});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _targetCountController;
  late TextEditingController _unitController;
  late IconData _selectedIcon;
  late Color _selectedColor;
  late HabitFrequency _selectedFrequency;

  final List<IconData> _curatedIcons = [
    Icons.fitness_center,
    Icons.menu_book,
    Icons.self_improvement,
    Icons.water_drop,
    Icons.code,
    Icons.music_note,
    Icons.bedtime,
    Icons.directions_walk,
    Icons.restaurant,
    Icons.brush,
    Icons.pets,
    Icons.favorite,
    Icons.savings,
    Icons.sunny,
    Icons.nightlight_round,
    Icons.work,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.habit?.description ?? '',
    );
    _targetCountController = TextEditingController(
      text: widget.habit?.targetCount?.toString() ?? '',
    );
    _unitController = TextEditingController(text: widget.habit?.unit ?? '');
    _selectedIcon = widget.habit?.icon ?? Icons.fitness_center;
    _selectedColor = widget.habit?.color ?? AppColors.seedColor;
    _selectedFrequency = widget.habit?.frequency ?? HabitFrequency.daily;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetCountController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final habitService = context.read<HabitService>();
      final targetCount = int.tryParse(_targetCountController.text);
      final unit = _unitController.text.trim();

      if (widget.habit != null) {
        habitService.updateHabit(
          widget.habit!.copyWith(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            icon: _selectedIcon,
            color: _selectedColor,
            frequency: _selectedFrequency,
            targetCount: targetCount,
            unit: unit.isNotEmpty ? unit : null,
          ),
        );
      } else {
        habitService.addHabit(
          Habit(
            id: '', // Service will generate ID
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            icon: _selectedIcon,
            color: _selectedColor,
            frequency: _selectedFrequency,
            targetCount: targetCount,
            unit: unit.isNotEmpty ? unit : null,
          ),
        );
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.habit == null ? 'Create Habit' : 'Edit Habit';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (widget.habit != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                context.read<HabitService>().deleteHabit(widget.habit!.id);
                context.pop();
              },
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.s16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                hintText: 'e.g. Morning Yoga',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a name' : null,
            ),
            const SizedBox(height: AppSpacing.s16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Why do you want to do this?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.s24),
            _buildSectionTitle('Daily Goal (Optional)'),
            const SizedBox(height: AppSpacing.s12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _targetCountController,
                    decoration: const InputDecoration(
                      labelText: 'Target',
                      hintText: '8',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _unitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      hintText: 'glasses',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s24),
            _buildSectionTitle('Icon'),
            const SizedBox(height: AppSpacing.s12),
            _buildIconPicker(),
            const SizedBox(height: AppSpacing.s24),
            _buildSectionTitle('Color'),
            const SizedBox(height: AppSpacing.s12),
            _buildColorPicker(),
            const SizedBox(height: AppSpacing.s24),
            _buildSectionTitle('Frequency'),
            const SizedBox(height: AppSpacing.s12),
            _buildFrequencySelector(),
            const SizedBox(height: AppSpacing.s48),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                widget.habit == null ? 'Create Habit' : 'Save Changes',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildIconPicker() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: AppSpacing.s12,
          crossAxisSpacing: AppSpacing.s12,
        ),
        itemCount: _curatedIcons.length,
        itemBuilder: (context, index) {
          final icon = _curatedIcons[index];
          final isSelected = _selectedIcon == icon;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: InkWell(
              onTap: () {
                setState(() => _selectedIcon = icon);
                HapticFeedback.lightImpact();
              },
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorPicker() {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppColors.habitColors.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s12),
        itemBuilder: (context, index) {
          final color = AppColors.habitColors[index];
          final isSelected = _selectedColor.value == color.value;
          return AnimatedScale(
            scale: isSelected ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: InkWell(
              onTap: () {
                setState(() => _selectedColor = color);
                HapticFeedback.lightImpact();
              },
              customBorder: const CircleBorder(),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: isSelected ? 12 : 4,
                      offset: Offset(0, isSelected ? 4 : 2),
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrequencySelector() {
    return Container(
      width: double.infinity,
      child: SegmentedButton<HabitFrequency>(
        segments: const [
          ButtonSegment(
            value: HabitFrequency.daily,
            label: Text('Daily'),
            icon: Icon(Icons.calendar_today_outlined, size: 16),
          ),
          ButtonSegment(
            value: HabitFrequency.weekdays,
            label: Text('Weekdays'),
            icon: Icon(Icons.work_outline, size: 16),
          ),
          ButtonSegment(
            value: HabitFrequency.weekends,
            label: Text('Weekends'),
            icon: Icon(Icons.wb_sunny_outlined, size: 16),
          ),
        ],
        selected: {_selectedFrequency},
        onSelectionChanged: (value) {
          setState(() => _selectedFrequency = value.first);
          HapticFeedback.lightImpact();
        },
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          visualDensity: VisualDensity.comfortable,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
