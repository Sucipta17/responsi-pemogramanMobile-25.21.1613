import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  runApp(const AppProviderWrapper(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Tema terpusat.
  static final ThemeData _theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    appBarTheme: const AppBarTheme(centerTitle: true),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Mahasiswa & Catatan Kuliah',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      home: const HomeScreen(),
    );
  }
}
