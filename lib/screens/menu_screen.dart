import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepseek_client/deepseek_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String respuestaDeepSeek = "Cargando respuesta...";
  Future<void> obtenerRespuesta() async {
    final usuario = FirebaseAuth.instance.currentUser!.uid;

    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false, // evita que se cierre tocando fuera
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.stretchedDots(
            color: Colors.blue.shade400,
            size: 75,
          ),
        );
      },
    );

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("configuraciones")
          .doc(usuario)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final response = await DeepSeekClient.sendMessage(
          messages: [
            Message(
              content:
                  "Dame un menú semanal en formato JSON, sin explicaciones, solo la estructura como objeto JSON, con los días como claves y cada día con desayuno, comida y cena. "
                  "El objetivo de la dieta es: $opcionActual."
                  "Ten en cuenta que tengo ${data['edad']} años, soy ${data['sexo']}, mido ${data['altura']} cm y peso${data['peso']} kilogramos,"
                  "soy alergico a ${data['alergias']} e intolerate a ${data['intolerancias']}, prefiero que la dieta incluya ${data['gustos']}"
                  "y que a ser posible no incluya ${data['disgustos']}. Tiene que ser una dieta ${data['dieta']}, ten en cuenta que mi religión es ${data['religion']}"
                  "y mi presupuesto es de ${data['precio']}."
                  "Ten en cuenta que soy de España",
              role: "system",
            ),
          ],
          model: DeekSeekModels.chat,
        );

        String rawContent = response.choices!.first.message?.content ?? "";
        rawContent =
            rawContent.replaceAll("```json", "").replaceAll("```", "").trim();

        final Map<String, dynamic> menuData = json.decode(rawContent);

        await FirebaseFirestore.instance
            .collection("menus")
            .doc(usuario)
            .set(menuData);

        // Cerrar el loading una vez terminado
        Navigator.pop(context);

        // Opcional: volver a la pantalla anterior o mostrar éxito
        Navigator.pop(context); //
      }

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

      String rawContent = response.choices!.first.message?.content ?? "";
      rawContent =
          rawContent.replaceAll("```json", "").replaceAll("```", "").trim();

      final Map<String, dynamic> menuData = json.decode(rawContent);

      await FirebaseFirestore.instance
          .collection("menus")
          .doc(usuario)
          .set(menuData);

      // Cerrar el loading una vez terminado
      Navigator.pop(context);

      // Opcional: volver a la pantalla anterior o mostrar éxito
      Navigator.pop(context); // ← esto te devuelve a la pantalla anterior
    } catch (e) {
      Navigator.pop(context); // cerrar el loading en caso de error también
      setState(() {
        respuestaDeepSeek = "Error al obtener respuesta: $e";
      });
    }
  }

  Future<void> eliminarLista() async {
    final usuario = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("listas").doc(usuario).delete();
  }

  List<String> opciones = ["Perder peso", "Ganar peso", "Mantener peso"];
  String opcionActual = "Perder peso";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Elige tu objetivo",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.blue.shade400,
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
                  obtenerRespuesta();
                  eliminarLista();
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
