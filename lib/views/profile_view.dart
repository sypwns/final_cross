import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/pdf_service.dart';
import '../viewmodels/app_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, vm, _) {
        final user = FirebaseAuth.instance.currentUser;

        final name =
            user?.displayName?.isNotEmpty == true
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
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              name,

                              style:
                                  Theme.of(
                                    context,
                                  )
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                            ),

                            Text(
                              user?.email ??
                                  'No email',
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            const Text(
                              'Organized • Focused • Productive',
                            ),
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        'Task Statistics',

                        style:
                            Theme.of(
                              context,
                            )
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        height: 190,

                        child:
                            totalTasks == 0
                                ? const Center(
                                  child: Text(
                                    'No task data yet',
                                  ),
                                )
                                : PieChart(
                                  PieChartData(
                                    centerSpaceRadius:
                                        50,

                                    sections: [

                                      PieChartSectionData(
                                        value:
                                            completed
                                                .toDouble(),

                                        title:
                                            'Done',

                                        color:
                                            Colors
                                                .green,
                                      ),

                                      PieChartSectionData(
                                        value:
                                            pending
                                                .toDouble(),

                                        title:
                                            'Pending',

                                        color:
                                            Colors
                                                .orange,
                                      ),
                                    ],
                                  ),
                                ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        children: [

                          _miniStat(
                            'Total',
                            '$totalTasks',
                            Icons.list,
                          ),

                          _miniStat(
                            'Done',
                            '$completed',
                            Icons.done,
                          ),

                          _miniStat(
                            'Pending',
                            '$pending',
                            Icons.pending,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Card(
                child: SwitchListTile(
                  title:
                      const Text(
                        'Dark mode',
                      ),

                  subtitle: Text(
                    vm.isDark
                        ? 'Current: ON'
                        : 'Current: OFF',
                  ),

                  value:
                      vm.isDark,

                  onChanged:
                      (_) =>
                          vm.toggleTheme(),
                ),
              ),

              const SizedBox(height: 18),

              Card(
                child: ListTile(
                  leading:
                      const Icon(
                        Icons.cloud_done,
                      ),

                  title:
                      const Text(
                        'Firebase database',
                      ),

                  subtitle: Text(
                    '$totalTasks tasks and ${vm.notes.length} notes saved online',
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Card(
                child: ListTile(
                  leading:
                      const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                      ),

                  title:
                      const Text(
                        'Export Study Report',
                      ),

                  subtitle:
                      const Text(
                        'Generate PDF report',
                      ),

                  trailing:
                      FilledButton.icon(
                        onPressed:
                            () async {
                          await PdfService
                              .exportStudyReport(
                            vm,
                          );
                        },

                        icon:
                            const Icon(
                              Icons.download,
                            ),

                        label:
                            const Text(
                              'Export',
                            ),
                      ),
                ),
              ),

              const SizedBox(height: 18),

              const Card(
                child: ListTile(
                  leading:
                      Icon(
                        Icons.info,
                      ),

                  title:
                      Text(
                        'Version',
                      ),

                  subtitle:
                      Text(
                        '1.0.0 Final Project',
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _miniStat(
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        children: [

          Icon(icon),

          const SizedBox(
            height: 8,
          ),

          Text(
            value,

            style:
                const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
          ),

          Text(title),
        ],
      ),
    );
  }
}