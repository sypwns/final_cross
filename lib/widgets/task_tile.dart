import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final StudyTask task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskTile({super.key, required this.task, required this.onToggle, required this.onDelete});

  Color get priorityColor {
    switch (task.priority) {
      case 'High': return Colors.redAccent;
      case 'Medium': return Colors.orangeAccent;
      default: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(22)),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          leading: Checkbox(value: task.isCompleted, onChanged: (_) => onToggle()),
          title: Text(task.title, style: TextStyle(fontWeight: FontWeight.w700, decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
          subtitle: Text('${task.description}\nDeadline: ${DateFormat('MMM d, yyyy').format(task.deadline)}'),
          isThreeLine: true,
          trailing: Chip(label: Text(task.priority), backgroundColor: priorityColor.withOpacity(.16), labelStyle: TextStyle(color: priorityColor, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
