import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void cerrarSesion() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: cerrarSesion, icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text("Logeao"),
      ),
    );
  }
}
