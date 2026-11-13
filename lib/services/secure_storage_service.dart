import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Layanan penyimpanan terenkripsi untuk isi catatan.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  String _key(String noteId) => 'note_content_$noteId';

  /// Menyimpan isi catatan secara terenkripsi.
  Future<void> saveContent(String noteId, String content) async {
    await _storage.write(key: _key(noteId), value: content);
  }

  /// Membaca isi catatan. Mengembalikan `null` jika tidak ada.
  Future<String?> getContent(String noteId) async {
    return _storage.read(key: _key(noteId));
  }

  /// Menghapus isi catatan.
  Future<void> deleteContent(String noteId) async {
    await _storage.delete(key: _key(noteId));
  }
}
