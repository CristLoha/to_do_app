import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



enum TaskAction { toggleComplete, edit, delete }

class TaskListItem extends StatelessWidget {
  final Todo task;
  final Function(TaskAction) onActionSelected;
  final Color color;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onActionSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Text(
                  task.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted
                        ? Colors.black.withOpacity(0.6)
                        : Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Positioned(
              top: -4,
              right: -4,
              child: PopupMenuButton<TaskAction>(
                onSelected: onActionSelected,
                icon: const Icon(Icons.more_vert),
                tooltip: 'Opsi Lainnya',
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<TaskAction>>[
                    if (!task.isCompleted)
                      const PopupMenuItem<TaskAction>(
                        value: TaskAction.toggleComplete,
                        child: ListTile(
                          leading: Icon(Icons.check_circle_outline),
                          title: Text('Tandai Selesai'),
                        ),
                      ),
                    if (task.isCompleted)
                      const PopupMenuItem<TaskAction>(
                        value: TaskAction.toggleComplete,
                        child: ListTile(
                          leading: Icon(Icons.replay_circle_filled_outlined),
                          title: Text('Tandai Belum Selesai'),
                        ),
                      ),
                    if (!task.isCompleted)
                      const PopupMenuItem<TaskAction>(
                        value: TaskAction.edit,
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Edit'),
                        ),
                      ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<TaskAction>(
                      value: TaskAction.delete,
                      child: ListTile(
                        leading: Icon(Icons.delete_outline, color: Colors.red),
                        title: Text(
                          'Hapus',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ),
          ],
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
