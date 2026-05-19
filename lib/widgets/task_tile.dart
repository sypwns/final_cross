import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final StudyTask task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  Color get priorityColor {
    switch (task.priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      default:
        return Colors.green;
    }
  }

  String get statusText {
    return task.isCompleted ? 'Done' : 'To Do';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          onTap: () {
            _showTaskDetails(context);
          },
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => onToggle(),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            '${task.description}\nDeadline: ${DateFormat('MMM d, yyyy').format(task.deadline)}',
          ),
          isThreeLine: true,
          trailing: Chip(
            label: Text(task.priority),
            backgroundColor: priorityColor.withOpacity(.16),
            labelStyle: TextStyle(
              color: priorityColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showTaskDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Icon(
                      Icons.task_alt,
                      color: priorityColor,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _infoCard(
                  icon: Icons.description,
                  title: 'Description',
                  value: task.description,
                ),

                const SizedBox(height: 12),

                _infoCard(
                  icon: Icons.flag,
                  title: 'Priority',
                  value: task.priority,
                ),

                const SizedBox(height: 12),

                _infoCard(
                  icon: Icons.calendar_month,
                  title: 'Deadline',
                  value: DateFormat('MMMM d, yyyy').format(task.deadline),
                ),

                const SizedBox(height: 12),

                _infoCard(
                  icon: task.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  title: 'Status',
                  value: statusText,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onEdit();
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.grey.withOpacity(.10),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}