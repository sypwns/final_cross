import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../viewmodels/app_view_model.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_tile.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, vm, _) {
        final user = FirebaseAuth.instance.currentUser;
        final name = user?.displayName?.isNotEmpty == true
            ? user!.displayName!
            : 'Student';

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: vm.loadAll,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $name 👋',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Text('Plan your day and stay productive'),
                      ],
                    ),
                    IconButton(
                      onPressed: vm.toggleTheme,
                      icon: Icon(
                        vm.isDark ? Icons.light_mode : Icons.dark_mode,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6C63FF),
                        Color(0xFF00C2A8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weekly Progress',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(vm.completionRate * 100).toStringAsFixed(0)}% completed',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: vm.completionRate,
                          minHeight: 12,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Smart Daily Study Plan',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(vm.smartStudyPlan),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    StatCard(
                      title: 'Completed',
                      value: '${vm.completedTasks}',
                      icon: Icons.done_all,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 12),
                    StatCard(
                      title: 'Pending',
                      value: '${vm.pendingTasks}',
                      icon: Icons.pending_actions,
                      color: Colors.orange,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'Upcoming Tasks',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 12),

                if (vm.upcomingTasks.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        'No upcoming tasks yet. Add your first task!',
                      ),
                    ),
                  )
                else
                  ...vm.upcomingTasks.map(
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
                      onEdit: () {},
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}