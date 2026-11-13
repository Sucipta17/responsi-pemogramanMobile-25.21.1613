import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';

/// InheritedWidget yang menyediakan state ke seluruh subtree.
class AppProvider extends InheritedWidget {
  final Student student;
  final List<Note> notes;
  final bool isLoading;
  final String? error;
  final void Function(Student) updateStudent;
  final Future<void> Function(Note) addNote;
  final Future<void> Function(String) deleteNote;

  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.isLoading,
    required this.error,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  static AppProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(result != null, 'AppProvider tidak ditemukan di widget tree');
    return result!;
  }

  @override
  bool updateShouldNotify(AppProvider old) =>
      student != old.student ||
      notes != old.notes ||
      isLoading != old.isLoading ||
      error != old.error;
}

/// StatefulWidget yang mengelola state dan menyediakan [AppProvider].
class AppProviderWrapper extends StatefulWidget {
  final Widget child;
  const AppProviderWrapper({super.key, required this.child});

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  final NoteRepository _repo = NoteRepository();

  Student _student = const Student(
    name: 'Nama Mahasiswa',
    nim: '123456789',
    programStudi: 'Teknik Informatika',
    email: 'mahasiswa@email.com',
  );
  List<Note> _notes = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await _repo.getNotes();
      if (!mounted) return;
      setState(() {
        _notes = notes;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      debugPrint('loadNotes gagal');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Gagal memuat catatan.';
      });
    }
  }

  void _updateStudent(Student s) => setState(() => _student = s);

  Future<void> _addNote(Note note) async {
    await _repo.addNote(note);
    setState(() => _notes = [note, ..._notes]);
  }

  Future<void> _deleteNote(String id) async {
    await _repo.deleteNote(id);
    setState(() => _notes = _notes.where((n) => n.id != id).toList());
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      isLoading: _loading,
      error: _error,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}
