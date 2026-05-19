import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../viewmodels/app_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(builder: (context, vm, _) {
      final user = FirebaseAuth.instance.currentUser;
      final name = user?.displayName?.isNotEmpty == true
          ? user!.displayName!
          : 'Smart Student';

      final totalTasks = vm.tasks.length;
      final completed = vm.completedTasks;
      final pending = vm.pendingTasks;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile & Stats'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      child: Text(
                        name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(user?.email ?? 'No email'),
                          const SizedBox(height: 4),
                          const Text('Organized • Focused • Productive'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Statistics',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 190,
                      child: totalTasks == 0
                          ? const Center(child: Text('No task data yet'))
                          : PieChart(
                              PieChartData(
                                sectionsSpace: 4,
                                centerSpaceRadius: 50,
                                sections: [
                                  PieChartSectionData(
                                    value: completed.toDouble(),
                                    title: 'Done',
                                    radius: 58,
                                    color: Colors.green,
                                  ),
                                  PieChartSectionData(
                                    value: pending.toDouble(),
                                    title: 'Pending',
                                    radius: 58,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                            ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        _miniStat('Total', '$totalTasks', Icons.list),
                        _miniStat('Done', '$completed', Icons.check_circle),
                        _miniStat('Pending', '$pending', Icons.timelapse),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievements 🏆',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),

                    _achievement(
                      context,
                      icon: Icons.task_alt,
                      title: 'First Task',
                      subtitle: totalTasks > 0
                          ? 'Unlocked: you created your first task'
                          : 'Create your first task to unlock',
                      unlocked: totalTasks > 0,
                    ),

                    _achievement(
                      context,
                      icon: Icons.local_fire_department,
                      title: 'Productive Student',
                      subtitle: completed >= 3
                          ? 'Unlocked: 3 tasks completed'
                          : 'Complete 3 tasks to unlock',
                      unlocked: completed >= 3,
                    ),

                    _achievement(
                      context,
                      icon: Icons.workspace_premium,
                      title: 'Task Master',
                      subtitle: completed >= 5
                          ? 'Unlocked: 5 tasks completed'
                          : 'Complete 5 tasks to unlock',
                      unlocked: completed >= 5,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Card(
              child: SwitchListTile(
                title: const Text('Dark mode'),
                subtitle: Text(vm.isDark ? 'Current: ON' : 'Current: OFF'),
                value: vm.isDark,
                onChanged: (_) => vm.toggleTheme(),
                secondary: const Icon(Icons.dark_mode),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.cloud_done),
                title: const Text('Firebase database'),
                subtitle: Text(
                  '$totalTasks tasks and ${vm.notes.length} notes saved online',
                ),
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Version'),
                subtitle: Text('1.0.0 Final Project'),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _miniStat(String title, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(title),
        ],
      ),
    );
  }

  Widget _achievement(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool unlocked,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: unlocked
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: unlocked ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unlocked ? '$title ✅' : '$title 🔒',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}