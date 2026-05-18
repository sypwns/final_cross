import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(builder: (context, vm, _) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile & Stats'), centerTitle: true),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Row(children: [
                const CircleAvatar(radius: 34, child: Icon(Icons.school, size: 34)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Smart Student', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const Text('Organized • Focused • Productive'),
                ])),
              ]),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Task Statistics', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 180,
                  child: PieChart(PieChartData(sectionsSpace: 4, centerSpaceRadius: 45, sections: [
                    PieChartSectionData(value: vm.completedTasks.toDouble(), title: 'Done', radius: 55, color: Colors.green),
                    PieChartSectionData(value: vm.pendingTasks.toDouble(), title: 'Pending', radius: 55, color: Colors.orange),
                  ])),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 18),
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Change app appearance'),
            value: vm.isDark,
            onChanged: (_) => vm.toggleTheme(),
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Local database'),
            subtitle: Text('${vm.tasks.length} tasks and ${vm.notes.length} notes saved offline'),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.0.0 Final Project'),
          ),
        ]),
      );
    });
  }
}
