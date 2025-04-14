import 'package:flutter/material.dart';
import 'package:proyecto_practica_ia/screens/login_screen.dart';
import 'package:proyecto_practica_ia/screens/singin_screen.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  // Enseñar página de login al principio
  bool showLoginScreen = true;

  // cambiar entre login y página de registro
  void toogleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(
        onTap: toogleScreens,
      );
    } else {
      return SinginScreen(onTap: toogleScreens);
    }
  }
}
