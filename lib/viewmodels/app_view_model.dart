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

  CollectionReference<Map<String, dynamic>> get _tasksRef {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks');
  }

  CollectionReference<Map<String, dynamic>> get _notesRef {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notes');
  }

  Future<void> init() async {
    await loadAll();
  }

  Future<void> loadAll() async {
    if (uid == null) return;

    isLoading = true;
    notifyListeners();

    final taskSnapshot = await _tasksRef.orderBy('deadline').get();

    tasks = taskSnapshot.docs.map((doc) {
      final data = doc.data();

      return StudyTask(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        deadline: DateTime.parse(data['deadline']),
        priority: data['priority'] ?? 'Medium',
        isCompleted: data['isCompleted'] == true,
        createdAt: DateTime.parse(data['createdAt']),
      );
    }).toList();

    final noteSnapshot =
        await _notesRef.orderBy('updatedAt', descending: true).get();

    notes = noteSnapshot.docs.map((doc) {
      final data = doc.data();

      return StudyNote(
        id: int.tryParse(doc.id),
        title: data['title'] ?? '',
        content: data['content'] ?? '',
        updatedAt: DateTime.parse(data['updatedAt']),
      );
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  List<StudyTask> get upcomingTasks => tasks;

  List<StudyTask> get todayTasks => tasks;

  int get completedTasks => tasks.where((task) => task.isCompleted).length;

  int get pendingTasks => tasks.where((task) => !task.isCompleted).length;

  double get completionRate {
    if (tasks.isEmpty) return 0;
    return completedTasks / tasks.length;
  }

  Future<void> addTask(StudyTask task) async {
    if (uid == null) return;

    final docRef = await _tasksRef.add(task.toMap());

    final newTask = task.copyWith(id: docRef.id);

    tasks.add(newTask);
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    if (uid == null) return;

    await _tasksRef.doc(id).delete();

    tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  Future<void> toggleTask(StudyTask task) async {
    if (uid == null || task.id == null) return;

    final newValue = !task.isCompleted;

    await _tasksRef.doc(task.id).update({
      'isCompleted': newValue,
    });

    task.isCompleted = newValue;
    notifyListeners();
  }

  Future<void> addNote(StudyNote note) async {
    if (uid == null) return;

    await _notesRef.add({
      'title': note.title,
      'content': note.content,
      'updatedAt': note.updatedAt.toIso8601String(),
    });

    await loadAll();
  }

  Future<void> deleteNote(int index) async {
    if (uid == null) return;
    if (index < 0 || index >= notes.length) return;

    final note = notes[index];
    final snapshot = await _notesRef.get();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      if (data['title'] == note.title &&
          data['content'] == note.content &&
          data['updatedAt'] == note.updatedAt.toIso8601String()) {
        await doc.reference.delete();
        break;
      }
    }

    notes.removeAt(index);
    notifyListeners();
  }

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}