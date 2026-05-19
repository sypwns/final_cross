import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../viewmodels/app_view_model.dart';

class PdfService {
  static Future<void> exportStudyReport(AppViewModel vm) async {
    final user = FirebaseAuth.instance.currentUser;

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Smart Study Planner Report',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Text('Student: ${user?.displayName ?? 'Student'}'),
              pw.Text('Email: ${user?.email ?? 'No email'}'),

              pw.SizedBox(height: 20),

              pw.Text(
                'Statistics',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.Text('Total tasks: ${vm.tasks.length}'),
              pw.Text('Completed tasks: ${vm.completedTasks}'),
              pw.Text('Pending tasks: ${vm.pendingTasks}'),
              pw.Text('Notes: ${vm.notes.length}'),
              pw.Text(
                'Progress: ${(vm.completionRate * 100).toStringAsFixed(0)}%',
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                'Smart Daily Study Plan',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.Text(vm.smartStudyPlan),

              pw.SizedBox(height: 20),

              pw.Text(
                'Tasks',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              ...vm.tasks.map(
                (task) => pw.Text(
                  '- ${task.title} | ${task.priority} | ${task.isCompleted ? 'Done' : 'Pending'}',
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}