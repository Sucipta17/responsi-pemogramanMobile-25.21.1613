import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../models/note.dart';
import '../services/secure_storage_service.dart';

/// Repository pattern: satu-satunya pintu akses data catatan & API.
class NoteRepository {
  static const String _metaKey = 'notes_meta';
  final SecureStorageService _secure;

  NoteRepository({SecureStorageService? secure})
      : _secure = secure ?? SecureStorageService();

  Future<List<Map<String, dynamic>>> _readMeta() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_metaKey);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> _writeMeta(List<Map<String, dynamic>> meta) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_metaKey, jsonEncode(meta));
  }

  /// Mengambil semua catatan (metadata + isi terenkripsi), terbaru di atas.
  Future<List<Note>> getNotes() async {
    final meta = await _readMeta();
    final notes = <Note>[];
    for (final m in meta) {
      final content = await _secure.getContent(m['id'] as String) ?? '';
      notes.add(Note.fromMeta(m, content));
    }
    notes.sort((a, b) => b.date.compareTo(a.date));
    return notes;
  }

  /// Menambah catatan baru.
  Future<void> addNote(Note note) async {
    final meta = await _readMeta();
    meta.add(note.toMetaJson());
    await _writeMeta(meta);
    await _secure.saveContent(note.id, note.content);
  }

  /// Menghapus catatan beserta isinya.
  Future<void> deleteNote(String id) async {
    final meta = await _readMeta();
    meta.removeWhere((m) => m['id'] == id);
    await _writeMeta(meta);
    await _secure.deleteContent(id);
  }

  /// HTTP GET ke API publik (/posts). Tidak mencetak token/data sensitif.
  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/posts?_limit=15');
    try {
      final res = await http.get(uri, headers: {
        'Accept': 'application/json',
        'x-api-key': AppConfig.apiKey,
      }).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>;
        return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      throw Exception('Gagal memuat data (kode ${res.statusCode})');
    } on SocketException {
      debugPrint('fetchPosts: SocketException');
      throw Exception('Tidak ada koneksi internet.');
    } on TimeoutException {
      debugPrint('fetchPosts: timeout');
      throw Exception('Permintaan melebihi batas waktu.');
    } on FormatException {
      throw Exception('Format data dari server tidak valid.');
    }
  }
}
