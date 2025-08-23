import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskListItem extends StatelessWidget {
  final Todo task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onTap;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: onChanged,
                activeColor: Theme.of(context).colorScheme.primary,
                shape: const CircleBorder(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted
                        ? Theme.of(context).textTheme.bodySmall?.color
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final bool isCompleted;
  final TaskPriority priority;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.isCompleted = false,
    this.priority = TaskPriority.none,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    TaskPriority? priority,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}

enum TaskPriority { none, low, medium, high }
