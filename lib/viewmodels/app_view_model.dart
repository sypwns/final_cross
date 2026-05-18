import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../models/note_model.dart';

class AppViewModel extends ChangeNotifier {
  List<StudyTask> tasks = [];
  List<StudyNote> notes = [];

  bool isDark = false;
  bool isLoading = false;

  Future<void> init() async {
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadAll() async {
    notifyListeners();
  }

  List<StudyTask> get upcomingTasks => tasks;

  List<StudyTask> get todayTasks => tasks;

  int get completedTasks =>
      tasks.where((task) => task.isCompleted).length;

  int get pendingTasks =>
      tasks.where((task) => !task.isCompleted).length;

  double get completionRate {
    if (tasks.isEmpty) return 0;
    return completedTasks / tasks.length;
  }

  void addTask(StudyTask task) {
    tasks.add(task);
    notifyListeners();
  }

  void deleteTask(int id) {
    tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void toggleTask(StudyTask task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void addNote(StudyNote note) {
    notes.add(note);
    notifyListeners();
  }

  void deleteNote(int index) {
    notes.removeAt(index);
    notifyListeners();
  }

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}