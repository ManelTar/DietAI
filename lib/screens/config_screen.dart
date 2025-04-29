import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_practica_ia/components/my_text_title.dart';
import 'package:proyecto_practica_ia/components/my_textfield.dart';
import 'package:proyecto_practica_ia/components/my_textoform.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final gustosController = TextEditingController();
  final disgustosController = TextEditingController();
  String valorDropDown = 'Hombre';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: const Text(
          "Configura tú menú",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 15,
          ),
          // Edad
          MyTextoform(
            text: "Edad",
            textInput: "Edad",
          ),
          const SizedBox(
            height: 15,
          ),
          // Sexo (dropdown)
          MyTextTitle(text: "Sexo"),
          Padding(
            padding: EdgeInsets.only(left: 25, top: 10),
            child: Row(children: [
              DropdownButton<String>(
                borderRadius: BorderRadius.circular(15),
                value: valorDropDown,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                onChanged: (value) {
                  setState(() {
                    valorDropDown = value!;
                  });
                },
                items: const [
                  DropdownMenuItem<String>(
                      value: "Hombre", child: Text("Hombre")),
                  DropdownMenuItem<String>(
                      value: "Mujer", child: Text("Mujer")),
                  DropdownMenuItem<String>(
                      value: "No binario", child: Text("No binario")),
                ],
              ),
            ]),
          ),
          const SizedBox(
            height: 15,
          ),
          MyTextoform(textInput: "Altura en cm", text: "Altura"),
          const SizedBox(
            height: 15,
          ),
          MyTextoform(textInput: "Peso", text: "Peso"),
          // Altura
          // Peso
          // Alergias (multiselect)
          // Intoleranciasconst 
          const SizedBox(
            height: 15,
          ),
          // Preferencias (gustos y disgustos)
          MyTextfield(
              controller: gustosController,
              hintText: "Gustos",
              keyboardType: TextInputType.multiline)
          // Tipo de dieta
          // Restricciones culturales
          // Precio
        ],
      )),
    );
  }
}
