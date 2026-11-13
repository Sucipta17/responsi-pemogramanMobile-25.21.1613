import 'package:flutter/material.dart';

import '../providers/app_provider.dart';
import '../utils/validators.dart';
import '../widgets/profile_card.dart';

/// Layar profil mahasiswa + tombol Edit Profil.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _edited = false;

  Future<void> _showEditDialog() async {
    final provider = AppProvider.of(context);
    final s = provider.student;
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: s.name);
    final nim = TextEditingController(text: s.nim);
    final prodi = TextEditingController(text: s.programStudi);
    final email = TextEditingController(text: s.email);

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (v) => Validators.validateRequired(v, 'Nama'),
                ),
                TextFormField(
                  controller: nim,
                  decoration: const InputDecoration(labelText: 'NIM'),
                  keyboardType: TextInputType.number,
                  validator: (v) => Validators.validateRequired(v, 'NIM'),
                ),
                TextFormField(
                  controller: prodi,
                  decoration: const InputDecoration(labelText: 'Program Studi'),
                  validator: (v) =>
                      Validators.validateRequired(v, 'Program studi'),
                ),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(ctx, true);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (saved == true) {
      provider.updateStudent(s.copyWith(
        name: Validators.sanitize(name.text),
        nim: Validators.sanitize(nim.text),
        programStudi: Validators.sanitize(prodi.text),
        email: Validators.sanitize(email.text),
      ));
      setState(() => _edited = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = AppProvider.of(context).student;

    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _edited);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Profil Mahasiswa')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ProfileCard(student: student),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _showEditDialog,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
