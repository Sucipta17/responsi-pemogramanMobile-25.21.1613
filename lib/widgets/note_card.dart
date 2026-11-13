import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';

/// Kartu satu catatan.
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateFormat('dd MMM yyyy, HH:mm').format(note.date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        title: Text(note.title, style: theme.textTheme.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text(date, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Hapus catatan',
          onPressed: onDelete,
        ),
      ),
    );
  }
}