import 'package:flutter_test/flutter_test.dart';
import 'package:smart_study_planner/models/task_model.dart';

void main() {
  test('StudyTask converts to map and back correctly', () {
    final task = StudyTask(
      id: 1,
      title: 'Math homework',
      description: 'Chapter 3 exercises',
      deadline: DateTime(2026, 5, 20),
      priority: 'High',
      isCompleted: false,
      createdAt: DateTime(2026, 5, 18),
    );

    final restored = StudyTask.fromMap(task.toMap());
    expect(restored.title, 'Math homework');
    expect(restored.priority, 'High');
    expect(restored.isCompleted, false);
  });
}
