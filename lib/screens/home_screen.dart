import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deepseek_client/deepseek_client.dart';
import 'package:proyecto_practica_ia/components/my_button.dart';
import 'package:proyecto_practica_ia/components/my_card.dart';
import 'package:proyecto_practica_ia/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nombreUsuario = FirebaseAuth.instance.currentUser;
  final textoController = TextEditingController();
  String respuestaDeepSeek = "Cargando respuesta...";

  @override
  void initState() {
    super.initState();
  }

  void cerrarSesion() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> guardarMenuEnFirestore(String menuJson) async {
    final data = json.decode(menuJson); // convierte el texto a mapa
    await FirebaseFirestore.instance.collection("menus").add(data);
  }

  Future<void> obtenerRespuesta() async {
    final usuario = FirebaseAuth.instance.currentUser?.uid;
    try {
      final response = await DeepSeekClient.sendMessage(
        messages: [
          Message(
            content:
                "Dame un menú semanal en formato JSON, sin explicaciones, solo la estructura como objeto JSON, con los días como claves y cada día con desayuno, comida y cena.",
            role: "system",
          ),
        ],
        model: DeekSeekModels.chat,
      );

      // 🔹 Obtener el contenido de la IA
      String rawContent = response.choices!.first.message?.content ?? "";

      // ✂️ Limpiar el posible bloque Markdown
      rawContent =
          rawContent.replaceAll("```json", "").replaceAll("```", "").trim();

      // 🔄 Convertir a Map
      final Map<String, dynamic> menuData = json.decode(rawContent);

      // 🔥 Guardar en Firebase
      await FirebaseFirestore.instance
          .collection("menus")
          .doc(usuario as String)
          .set(menuData);

      // 🧾 Mostrar la respuesta como texto en la app (opcional, para debug)
      // setState(() {
      //   respuestaDeepSeek =
      //       json.encode(menuData); // lo convierte de vuelta a String
      // });
    } catch (e) {
      setState(() {
        respuestaDeepSeek = "Error al obtener respuesta: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final diasOrdenados = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];

    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: cerrarSesion, icon: Icon(Icons.logout)),
        ],
        title: const Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 🧠 Input para IA
            Row(
              children: [
                Expanded(
                  child: MyTextfield(
                    controller: textoController,
                    hintText: "Pregunta a la IA",
                  ),
                ),
                const SizedBox(width: 10),
                MyButton(
                  text: "📤",
                  onTap: obtenerRespuesta,
                ),
              ],
            ),
            const SizedBox(height: 20),

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
                    'lunes',
                    'martes',
                    'miércoles',
                    'jueves',
                    'viernes',
                    'sábado',
                    'domingo',
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
          ],
        ),
      ),
    );
  }
}
