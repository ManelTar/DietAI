import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepseek_client/deepseek_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_practica_ia/screens/home_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String respuestaDeepSeek = "Cargando respuesta...";
  Future<void> obtenerRespuesta() async {
    final usuario = FirebaseAuth.instance.currentUser?.uid;
    try {
      final response = await DeepSeekClient.sendMessage(
        messages: [
          Message(
            content:
                "Dame un menú semanal en formato JSON, sin explicaciones, solo la estructura como objeto JSON, con los días como claves y cada día con desayuno, comida y cena. "
                "El objetivo de la dieta es: $opcionActual.",
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

  List<String> opciones = ["Perder peso", "Ganar peso", "Mantener peso"];
  String opcionActual = "Perder peso";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Elige tu objetivo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Opciones en forma de RadioList
            Expanded(
              child: ListView(
                children: opciones.map((opcion) {
                  return ListTile(
                    title: Text(opcion),
                    leading: Radio<String>(
                      value: opcion,
                      groupValue: opcionActual,
                      onChanged: (value) {
                        setState(() {
                          opcionActual = value!;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            // Botón abajo
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí haces algo con la opción seleccionada
                  obtenerRespuesta(); // ← ¡Aquí se lanza la petición!
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: const Text("Generar menú"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
