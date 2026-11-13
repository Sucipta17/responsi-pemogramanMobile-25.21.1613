import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import '../widgets/profile_card.dart';
import 'note_form_screen.dart';
import 'posts_screen.dart';
import 'profile_screen.dart';

/// Layar utama: profil singkat + daftar catatan.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openProfile(BuildContext context) async {
    final edited = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
    if (edited == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil diperbarui')),
      );
    }
  }

  Future<void> _openForm(BuildContext context) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NoteFormScreen()),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan tersimpan')),
      );
    }
  }

  /// Menampilkan detail lengkap catatan.
  void _showDetail(BuildContext context, Note note) {
    final date = DateFormat('dd MMM yyyy, HH:mm').format(note.date);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(note.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: Theme.of(ctx).textTheme.bodySmall),
              const SizedBox(height: 12),
              Text(note.content),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, String id, String title) async {
    final deleteNote = AppProvider.of(context).deleteNote;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('Catatan "$title" akan dihapus permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Hapus')),
        ],
      ),
    );
    if (ok == true) {
      try {
        await deleteNote(id);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus catatan')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppProvider.of(context);

    Widget body;
    if (app.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (app.error != null) {
      body = EmptyState(message: app.error!, icon: Icons.error_outline);
    } else if (app.notes.isEmpty) {
      body = const EmptyState();
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.only(bottom: 88),
        itemCount: app.notes.length,
        itemBuilder: (_, i) {
          final note = app.notes[i];
          return NoteCard(
            note: note,
            onTap: () => _showDetail(context, note),
            onDelete: () => _confirmDelete(context, note.id, note.title),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Kuliah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download_outlined),
            tooltip: 'Data online',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PostsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
            onPressed: () => _openProfile(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: ProfileCard(student: app.student, compact: true),
          ),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        tooltip: 'Tambah catatan',
        child: const Icon(Icons.add),
      ),
    );
  }
}