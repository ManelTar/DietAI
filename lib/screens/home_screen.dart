import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_practica_ia/components/my_button.dart';
import 'package:proyecto_practica_ia/components/my_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Dietas",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 26),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 15),
              MyProfilePicture(),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  FirebaseAuth.instance.currentUser!.displayName.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Spacer(), // Esto empuja lo siguiente al fondo
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: MyButton(
                  text: "Cerrar sesión",
                  onTap: cerrarSesion,
                  color: Theme.of(context).colorScheme.error,
                  textColor: Theme.of(context).colorScheme.onError,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    return Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: Theme.of(context).colorScheme.secondary,
                        size: 75,
                      ),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [MyPopButton()]),
            )
          ],
        ),
      ),
    );
  }
}
