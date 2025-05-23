import 'package:flutter/material.dart';
import 'package:proyecto_practica_ia/components/my_themecode.dart';
import 'package:proyecto_practica_ia/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DietAI',
      theme: AppTheme.light, // Tema claro personalizado
      darkTheme: AppTheme.dark, // Tema oscuro personalizado
      themeMode: ThemeMode.system, // Usa el modo del sistema (puedes cambiarlo)
      home: const AuthScreen(),
    );
  }
}
