import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi yang dibaca dari file `.env` (tanpa hardcoded credential).
class AppConfig {
  AppConfig._();

  /// Memuat file `.env`. Dipanggil sekali di `main()`.
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  /// URL dasar API publik.
  static String get baseUrl =>
      dotenv.maybeGet('BASE_URL') ?? 'https://jsonplaceholder.typicode.com';

  /// API key (dummy). Jangan pernah dicetak ke log.
  static String get apiKey => dotenv.maybeGet('API_KEY') ?? '';
}
