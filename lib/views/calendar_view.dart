import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_view_model.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(builder: (context, vm, _) {
      final grouped = <String, int>{};
      for (final task in vm.tasks) {
        final key = DateFormat('MMM d, yyyy').format(task.deadline);
        grouped[key] = (grouped[key] ?? 0) + 1;
      }
      return Scaffold(
        appBar: AppBar(title: const Text('Calendar'), centerTitle: true),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(28)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(DateFormat('EEEE').format(DateTime.now()), style: Theme.of(context).textTheme.titleMedium),
                Text(DateFormat('MMMM d, yyyy').format(DateTime.now()), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('${vm.todayTasks.length} task(s) due today'),
              ]),
            ),
            const SizedBox(height: 24),
            Text('Deadline Overview', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (grouped.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No deadlines yet')))
            else
              ...grouped.entries.map((e) => Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${e.value}')),
                      title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${e.value} study task(s)'),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  )),
          ],
        ),
      );
    });
  }
}
