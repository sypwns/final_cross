import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../viewmodels/app_view_model.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(builder: (context, vm, _) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notes'), centerTitle: true),
        floatingActionButton: FloatingActionButton(onPressed: () => _showNoteSheet(context), child: const Icon(Icons.add)),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: vm.notes.isEmpty
              ? [const SizedBox(height: 140), const Center(child: Text('No notes yet'))]
              : vm.notes.map((note) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(18),
                      title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${note.content}\nUpdated: ${DateFormat('MMM d, HH:mm').format(note.updatedAt)}'),
                      isThreeLine: true,
                      trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => vm.deleteNote(note.id!)),
                    ),
                  )).toList(),
        ),
      );
    });
  }

  void _showNoteSheet(BuildContext context) {
    final title = TextEditingController();
    final content = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('New Note', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(controller: title, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: content, maxLines: 4, decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (title.text.trim().isEmpty) return;
                Provider.of<AppViewModel>(context, listen: false).addNote(StudyNote(title: title.text.trim(), content: content.text.trim(), updatedAt: DateTime.now()));
                Navigator.pop(sheetContext);
              },
              child: const Text('Save Note'),
            ),
          ),
        ]),
      ),
    );
  }
}
