import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../viewmodels/app_view_model.dart';
import '../widgets/task_tile.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(builder: (context, vm, _) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tasks'), centerTitle: true),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showTaskSheet(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Task'),
        ),
        body: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: vm.tasks.isEmpty
                    ? [const SizedBox(height: 120), const Center(child: Text('No tasks yet'))]
                    : vm.tasks.map((task) => TaskTile(task: task, onToggle: () => vm.toggleTask(task), onDelete: () => vm.deleteTask(task.id!))).toList(),
              ),
      );
    });
  }

  void _showTaskSheet(BuildContext context) {
    final title = TextEditingController();
    final desc = TextEditingController();
    String priority = 'Medium';
    DateTime deadline = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (sheetContext) => StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('New Study Task', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: title, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: desc, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: priority,
              decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
              items: ['Low', 'Medium', 'High'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (value) => setState(() => priority = value ?? 'Medium'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(context: context, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime(2035), initialDate: deadline);
                if (picked != null) setState(() => deadline = picked);
              },
              icon: const Icon(Icons.calendar_today),
              label: Text('Deadline: ${deadline.day}.${deadline.month}.${deadline.year}'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (title.text.trim().isEmpty) return;
                  Provider.of<AppViewModel>(context, listen: false).addTask(StudyTask(
                    title: title.text.trim(),
                    description: desc.text.trim().isEmpty ? 'No description' : desc.text.trim(),
                    deadline: deadline,
                    priority: priority,
                    isCompleted: false,
                    createdAt: DateTime.now(),
                  ));
                  Navigator.pop(sheetContext);
                },
                child: const Text('Save Task'),
              ),
            ),
          ]),
        );
      }),
    );
  }
}
