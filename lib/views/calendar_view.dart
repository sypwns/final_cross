import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../viewmodels/app_view_model.dart';
import '../widgets/task_tile.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, vm, _) {
        final grouped = <String, List<StudyTask>>{};

        for (final task in vm.tasks) {
          final key = DateFormat('MMM d, yyyy').format(task.deadline);
          grouped.putIfAbsent(key, () => []);
          grouped[key]!.add(task);
        }

        final todayKey = DateFormat('MMM d, yyyy').format(DateTime.now());
        final todayCount = grouped[todayKey]?.length ?? 0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Calendar'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE').format(DateTime.now()),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      DateFormat('MMMM d, yyyy').format(DateTime.now()),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text('$todayCount task(s) due today'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Deadline Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              if (grouped.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text('No deadlines yet'),
                  ),
                )
              else
                ...grouped.entries.map((entry) {
                  final date = entry.key;
                  final tasks = entry.value;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${tasks.length}'),
                      ),
                      title: Text(
                        date,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${tasks.length} study task(s)'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showTasksForDate(context, date, tasks, vm);
                      },
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  void _showTasksForDate(
    BuildContext context,
    String date,
    List<StudyTask> tasks,
    AppViewModel vm,
  ) {
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
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                date,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text('${tasks.length} task(s) for this day'),
              const SizedBox(height: 20),

              ...tasks.map(
                (task) => TaskTile(
                  task: task,
                  onToggle: () async {
                    await vm.toggleTask(task);
                  },
                  onDelete: () async {
                    if (task.id != null) {
                      await vm.deleteTask(task.id!);
                      Navigator.pop(context);
                    }
                  },
                  onEdit: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}