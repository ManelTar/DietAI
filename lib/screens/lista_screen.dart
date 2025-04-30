import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepseek_client/deepseek_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_practica_ia/components/my_button.dart';
import 'package:proyecto_practica_ia/components/my_lista_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
      builder: (context) => Center(
        child: LoadingAnimationWidget.stretchedDots(
          color: Theme.of(context).colorScheme.secondary,
          size: 75,
        ),
      ),
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
                "Dame una lista de la compra en formato JSON válida, sin explicaciones ni comentarios, para el siguiente menú semanal: \n$menuJson. "
                "El formato debe ser exactamente este:\n\n"
                "{\n"
                "  \"lista_compra\": {\n"
                "    \"categoria_1\": [\n"
                "      { \"nombre\": \"Producto 1\", \"cantidad\": \"Cantidad 1\" },\n"
                "      { \"nombre\": \"Producto 2\", \"cantidad\": \"Cantidad 2\" }\n"
                "    ],\n"
                "    \"categoria_2\": [\n"
                "      { \"nombre\": \"Producto 3\", \"cantidad\": \"Cantidad 3\" }\n"
                "    ]\n"
                "  }\n"
                "}\n\n"
                "Cada categoría debe contener una **lista de productos**. Cada producto debe tener **nombre** y **cantidad** como claves. "
                "No uses mapas dentro de las categorías. No uses comentarios. No uses arrays anidados. ",
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Lista de la compra",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                          Text("No hay una lista de la compra aún.",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                          const SizedBox(
                            height: 10,
                          ),
                          MyButton(
                            text: "¡Crea una!",
                            onTap: obtenerLista,
                            color: Theme.of(context).colorScheme.secondary,
                            textColor:
                                Theme.of(context).colorScheme.onSecondary,
                          )
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
