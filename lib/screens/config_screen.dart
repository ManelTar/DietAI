import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_practica_ia/components/my_textoform.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  String valorDropDown = 'Uno';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(67, 0, 0, 0),
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          // Personas
          MyTextoform(text: "Número de personas"),
          const SizedBox(
            height: 15,
          ),
          // Edad
          MyTextoform(text: "Edad")
        ],
      )),
    );
  }
}
