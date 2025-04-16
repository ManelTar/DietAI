import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepseek_client/deepseek_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_practica_ia/components/my_button.dart';
import 'package:proyecto_practica_ia/components/my_card.dart';
import 'package:proyecto_practica_ia/components/my_lista_card.dart';

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  String respuestaDeepSeek = "Cargando respuesta...";
  Future<void> obtenerLista() async {
    final usuario = FirebaseAuth.instance.currentUser!.uid;

    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 🔹 Obtener el menú guardado
      final menuSnapshot = await FirebaseFirestore.instance
          .collection("menus")
          .doc(usuario)
          .get();

      final menuData = menuSnapshot.data();
      if (menuData == null) throw Exception("No hay menú guardado");

      final menuJson = json.encode(menuData);

      // 🔹 Pedir a la IA la lista basada en el menú
      final response = await DeepSeekClient.sendMessage(
        messages: [
          Message(
            content:
                "Dame una lista de la compra en formato JSON, sin explicaciones, "
                "con cantidades necesarias para cocinar todo lo del menú semanal. "
                "Aquí está el menú:\n$menuJson",
            role: "system",
          ),
        ],
        model: DeekSeekModels.chat,
      );

      String rawContent = response.choices!.first.message?.content ?? "";
      rawContent =
          rawContent.replaceAll("```json", "").replaceAll("```", "").trim();

      final Map<String, dynamic> listaData = json.decode(rawContent);

      // 🔥 Guardar la lista en Firestore
      await FirebaseFirestore.instance
          .collection("listas")
          .doc(usuario)
          .set(listaData);

      Navigator.pop(context); // cerrar loading
      setState(() {}); // recargar pantalla
    } catch (e) {
      Navigator.pop(context);
      setState(() {
        respuestaDeepSeek = "Error al obtener respuesta: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Lista de la compra"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 📋 Menús desde Firestore
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("listas")
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
                    return Center(
                      child: Column(
                        children: [
                          const Text("No hay una lista de la compra aún.",
                              style: TextStyle(color: Colors.black)),
                          const SizedBox(
                            height: 10,
                          ),
                          MyButton(text: "¡Crea una!", onTap: obtenerLista)
                        ],
                      ),
                    );
                  }

                  final rawData = snapshot.data!.data();
                  if (rawData == null || rawData is! Map<String, dynamic>) {
                    return const Center(
                        child: Text("Datos inválidos en Firestore."));
                  }

                  final data = rawData['lista_compra'] as Map<String, dynamic>;

                  return ListView(
                    children: data.entries.map((entry) {
                      final titulo = entry.key
                          .replaceAll('_', ' ')
                          .split(' ')
                          .map((word) =>
                              word[0].toUpperCase() + word.substring(1))
                          .join(' ');

                      final productosRaw = entry.value;

                      late final List<Map<String, dynamic>> productos;

                      if (productosRaw is List) {
                        productos = productosRaw.cast<Map<String, dynamic>>();
                      } else if (productosRaw is Map<String, dynamic>) {
                        productos = productosRaw.entries.map((e) {
                          return {
                            "nombre": e.key,
                            "cantidad": e.value.toString(),
                          };
                        }).toList();
                      } else {
                        return ListTile(
                          title: Text("⚠️ Formato incorrecto en '$titulo'"),
                          subtitle: Text("Datos no compatibles."),
                        );
                      }

                      return ListaCard(titulo: titulo, productos: productos);
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
