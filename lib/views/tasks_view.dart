import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../viewmodels/app_view_model.dart';
import '../widgets/task_tile.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, vm, _) {
        final allTasks = vm.tasks;
        final doneTasks = allTasks.where((t) => t.isCompleted).toList();
        final todoTasks = allTasks.where((t) => !t.isCompleted).toList();

        final now = DateTime.now();
        final inProgressTasks = allTasks.where((t) {
          return !t.isCompleted && t.deadline.difference(now).inDays <= 3;
        }).toList();

        List<StudyTask> filteredTasks;

        if (selectedFilter == 'Done') {
          filteredTasks = doneTasks;
        } else if (selectedFilter == 'To Do') {
          filteredTasks = todoTasks;
        } else if (selectedFilter == 'In Progress') {
          filteredTasks = inProgressTasks;
        } else {
          filteredTasks = allTasks;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Tasks'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showTaskSheet(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Task'),
          ),
          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _filterChip('All', allTasks.length, Icons.list),
                        _filterChip(
                          'To Do',
                          todoTasks.length,
                          Icons.radio_button_unchecked,
                        ),
                        _filterChip(
                          'In Progress',
                          inProgressTasks.length,
                          Icons.timelapse,
                        ),
                        _filterChip(
                          'Done',
                          doneTasks.length,
                          Icons.check_circle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '$selectedFilter Tasks',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    if (filteredTasks.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(
                          child: Text('No tasks in this category'),
                        ),
                      )
                    else
                      ...filteredTasks.map(
  (task) => TaskTile(
    task: task,

    onToggle: () async {
      await vm.toggleTask(task);
    },

    onDelete: () async {
      if (task.id != null) {
        await vm.deleteTask(task.id!);
      }
    },

    onEdit: () {
      _showEditSheet(context, task);
    },
  ),
),
                  ],
                ),
        );
      },
    );
  }

  Widget _filterChip(String label, int count, IconData icon) {
    final selected = selectedFilter == label;

    return ChoiceChip(
      selected: selected,
      avatar: Icon(
        icon,
        size: 18,
      ),
      label: Text('$label $count'),
      onSelected: (_) {
        setState(() {
          selectedFilter = label;
        });
      },
    );
  }

  void _showTaskSheet(BuildContext context) {
    final title = TextEditingController();
    final desc = TextEditingController();
    String priority = 'Medium';
    DateTime deadline = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Study Task',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: title,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: desc,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: priority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Low', 'Medium', 'High']
                        .map(
                          (p) => DropdownMenuItem(
                            value: p,
                            child: Text(p),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        priority = value ?? 'Medium';
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 1),
                        ),
                        lastDate: DateTime(2035),
                        initialDate: deadline,
                      );

                      if (picked != null) {
                        setState(() {
                          deadline = picked;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      'Deadline: ${deadline.day}.${deadline.month}.${deadline.year}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        if (title.text.trim().isEmpty) return;

                        final task = StudyTask(
                          title: title.text.trim(),
                          description: desc.text.trim().isEmpty
                              ? 'No description'
                              : desc.text.trim(),
                          deadline: deadline,
                          priority: priority,
                          isCompleted: false,
                          createdAt: DateTime.now(),
                        );

                        Navigator.pop(sheetContext);

                        try {
                          await Provider.of<AppViewModel>(
                            context,
                            listen: false,
                          ).addTask(task);
                        } catch (e) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Save error: $e'),
                            ),
                          );
                        }
                      },
                      child: const Text('Save Task'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
void _showEditSheet(BuildContext context, StudyTask task) {
  final title = TextEditingController(text: task.title);
  final desc = TextEditingController(text: task.description);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,

    builder: (_) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            const Text(
              'Edit Task',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: title,
              decoration:
                  const InputDecoration(
                    labelText: 'Title',
                  ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: desc,
              decoration:
                  const InputDecoration(
                    labelText: 'Description',
                  ),
            ),

            const SizedBox(height: 20),

            FilledButton(
              onPressed: () async {

                task.title = title.text;

                task.description = desc.text;

                await Provider.of<AppViewModel>(
                  context,
                  listen: false,
                ).toggleTask(task);

                Navigator.pop(context);
              },

              child:
                  const Text('Save'),
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}