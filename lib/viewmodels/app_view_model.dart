import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';
import '../models/note_model.dart';

class AppViewModel extends ChangeNotifier {
  List<StudyTask> tasks = [];
  List<StudyNote> notes = [];

  bool isDark = false;
  bool isLoading = false;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _tasksRef =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks');

  CollectionReference<Map<String, dynamic>> get _notesRef =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notes');

  Future<void> init() async {
    await loadAll();
  }

  Future<void> loadAll() async {
    if (uid == null) return;

    isLoading = true;
    notifyListeners();

    final taskSnapshot =
        await _tasksRef.orderBy('deadline').get();

    tasks = taskSnapshot.docs.map((doc) {
      final data = doc.data();

      return StudyTask(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        deadline: DateTime.parse(data['deadline']),
        priority: data['priority'] ?? 'Medium',
        isCompleted: data['isCompleted'] ?? false,
        createdAt: DateTime.parse(data['createdAt']),
      );
    }).toList();

    final noteSnapshot =
        await _notesRef
            .orderBy(
              'updatedAt',
              descending: true,
            )
            .get();

    notes = noteSnapshot.docs.map((doc) {
      final data = doc.data();

      return StudyNote(
        id: int.tryParse(doc.id),
        title: data['title'],
        content: data['content'],
        updatedAt: DateTime.parse(
          data['updatedAt'],
        ),
      );
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  List<StudyTask> get upcomingTasks => tasks;

  List<StudyTask> get todayTasks {
    final now = DateTime.now();

    return tasks.where((task) {
      return task.deadline.year == now.year &&
          task.deadline.month == now.month &&
          task.deadline.day == now.day;
    }).toList();
  }

  int get completedTasks =>
      tasks.where((e) => e.isCompleted).length;

  int get pendingTasks =>
      tasks.where((e) => !e.isCompleted).length;

  double get completionRate {
    if (tasks.isEmpty) return 0;

    return completedTasks / tasks.length;
  }

  /// SMART DAILY PLAN
  String get smartStudyPlan {
    if (tasks.isEmpty) {
      return 'Add tasks to generate your personalized study plan.';
    }

    final overdue = tasks.where(
      (t) =>
          !t.isCompleted &&
          t.deadline.isBefore(
            DateTime.now(),
          ),
    );

    final high = tasks.where(
      (t) =>
          !t.isCompleted &&
          t.priority == 'High',
    );

    if (overdue.isNotEmpty) {
      return '⚠ Start with overdue tasks. Complete them before creating new ones.';
    }

    if (high.isNotEmpty) {
      return '🔥 Focus on high priority tasks first and use Focus Timer.';
    }

    if (pendingTasks >= 5) {
      return '📚 You have many pending tasks. Break work into 25 minute sessions.';
    }

    if (completedTasks >= 5) {
      return '🏆 Great progress. Review notes and maintain momentum.';
    }

    return '✨ Finish today tasks and keep consistency.';
  }

  Future<void> addTask(
    StudyTask task,
  ) async {
    if (uid == null) return;

    final doc =
        await _tasksRef.add(
      task.toMap(),
    );

    tasks.add(
      task.copyWith(
        id: doc.id,
      ),
    );

    notifyListeners();
  }

  Future<void> deleteTask(
    String id,
  ) async {
    if (uid == null) return;

    await _tasksRef
        .doc(id)
        .delete();

    tasks.removeWhere(
      (e) => e.id == id,
    );

    notifyListeners();
  }

  Future<void> toggleTask(
    StudyTask task,
  ) async {
    if (uid == null || task.id == null) return;

    final value =
        !task.isCompleted;

    await _tasksRef
        .doc(task.id)
        .update({
      'isCompleted': value,
    });

    task.isCompleted = value;

    notifyListeners();
  }

  Future<void> addNote(
    StudyNote note,
  ) async {
    if (uid == null) return;

    await _notesRef.add({
      'title': note.title,
      'content': note.content,
      'updatedAt':
          note.updatedAt
              .toIso8601String(),
    });

    await loadAll();
  }

  Future<void> deleteNote(
    int index,
  ) async {
    if (uid == null) return;

    if (index >= notes.length) return;

    notes.removeAt(index);

    notifyListeners();
  }

  void toggleTheme() {
    isDark = !isDark;

    notifyListeners();
  }
}