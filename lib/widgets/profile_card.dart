import 'package:flutter/material.dart';

import '../models/student.dart';

/// Kartu profil mahasiswa (UI saja, tanpa logika).
class ProfileCard extends StatelessWidget {
  final Student student;
  final bool compact;

  const ProfileCard({super.key, required this.student, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (compact) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(radius: 24, child: Text(student.initials)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text('NIM: ${student.nim}',
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              child:
                  Text(student.initials, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 16),
            Text(student.name,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            _row(Icons.badge, 'NIM', student.nim),
            _row(Icons.school, 'Program Studi', student.programStudi),
            _row(Icons.email, 'Email', student.email),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
