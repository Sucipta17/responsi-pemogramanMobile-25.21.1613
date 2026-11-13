import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';

/// Form tambah catatan. Mengembalikan `true` via Navigator.pop jika berhasil.
class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Least privilege: hanya ambil fungsi addNote yang diperlukan.
    final addNote = AppProvider.of(context).addNote;
    setState(() => _saving = true);

    try {
      final note = Note(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: Validators.sanitize(_titleCtrl.text),
        content: Validators.sanitize(_contentCtrl.text),
        date: DateTime.now(),
      );
      await addNote(note);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan catatan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,
                validator: Validators.validateTitle,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentCtrl,
                decoration: const InputDecoration(
                  labelText: 'Isi catatan',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 8,
                maxLength: 1000,
                validator: Validators.validateContent,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
