import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deepseek_client/deepseek_client.dart';
import 'package:proyecto_practica_ia/components/my_button.dart';
import 'package:proyecto_practica_ia/components/my_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:proyecto_practica_ia/components/my_pop_button.dart';
import 'package:proyecto_practica_ia/components/my_profile_picture.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nombreUsuario = FirebaseAuth.instance.currentUser;
  final textoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void cerrarSesion() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(67, 0, 0, 0),
        actions: [
          IconButton(onPressed: cerrarSesion, icon: Icon(Icons.logout)),
        ],
        title: const Text("Home", style: TextStyle(color: Colors.white),),
      ),
      drawer: Drawer(
        surfaceTintColor: Colors.white,
        child: ListView(
          children: [
            MyProfilePicture()

          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 📋 Menús desde Firestore
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("menus")
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text("Cargando datos..."));
                  }

                  if (!snapshot.data!.exists) {
                    return const Center(
                        child: Text("No hay menús guardados aún."));
                  }

                  final rawData = snapshot.data!.data();
                  if (rawData == null || rawData is! Map<String, dynamic>) {
                    return const Center(
                        child: Text("Datos inválidos en Firestore."));
                  }

                  final data = rawData;
                  final diasOrdenados = [
                    'Lunes',
                    'Martes',
                    'Miércoles',
                    'Jueves',
                    'Viernes',
                    'Sábado',
                    'Domingo',
                  ];

                  final diasMenu = diasOrdenados
                      .where((dia) => data.containsKey(dia))
                      .map((dia) => MapEntry(dia, data[dia]))
                      .toList();

                  if (diasMenu.isEmpty) {
                    return const Center(child: Text("El menú está vacío."));
                  }

                  return ListView(
                    children: diasMenu.map((entry) {
                      final dia = entry.key;
                      final comidas = entry.value as Map<String, dynamic>;
                      return MenuCard(dia: dia, comidas: comidas);
                    }).toList(),
                  );
                },
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [MyPopButton()])
          ],
        ),
      ),
    );
  }
}
