import 'package:flutter/material.dart';

import '../repositories/note_repository.dart';
import '../widgets/empty_state.dart';

/// Menampilkan data dari API publik (HTTP GET) dalam ListView.
class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final NoteRepository _repo = NoteRepository();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchPosts();
  }

  void _retry() => setState(() => _future = _repo.fetchPosts());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Online (API)')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            final msg = snap.error.toString().replaceFirst('Exception: ', '');
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 56, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(msg, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                        onPressed: _retry, child: const Text('Coba lagi')),
                  ],
                ),
              ),
            );
          }
          final posts = snap.data ?? [];
          if (posts.isEmpty) {
            return const EmptyState(
                message: 'Tidak ada data.', icon: Icons.cloud_off);
          }
          return ListView.separated(
            itemCount: posts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => ListTile(
              leading: CircleAvatar(child: Text('${posts[i]['id']}')),
              title: Text('${posts[i]['title']}',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('${posts[i]['body']}'.replaceAll('\n', ' '),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          );
        },
      ),
    );
  }
}
