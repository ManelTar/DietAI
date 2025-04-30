import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_practica_ia/components/multiselect.dart';
import 'package:proyecto_practica_ia/components/my_button.dart';
import 'package:proyecto_practica_ia/components/my_dropdownmenu.dart';
import 'package:proyecto_practica_ia/components/my_text_title.dart';
import 'package:proyecto_practica_ia/components/my_textfield.dart';
import 'package:proyecto_practica_ia/components/my_textoform.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final usuario = FirebaseAuth.instance.currentUser!.uid;
  final gustosController = TextEditingController();
  final disgustosController = TextEditingController();
  final edadController = TextEditingController();
  final alturaController = TextEditingController();
  final pesoController = TextEditingController();
  final precioController = TextEditingController();

  List<String> selectedAlergias = [];
  List<String> selectedIntolerancias = [];

  String selectedGenero = 'Hombre'; // estado que controla el formulario
  String selectedDieta = 'Omnivora';
  String selectedReligion = 'Ninguna';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Configura tú menú",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
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
              controller: edadController,
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
                MyDropdownMenu(
                  items: ['Hombre', 'Mujer', 'No binario'],
                  initialValue: selectedGenero,
                  onChanged: (newValue) {
                    setState(() {
                      selectedGenero = newValue;
                    });
                  },
                ),
              ]),
            ),
            // Altura
            const SizedBox(
              height: 15,
            ),
            MyTextoform(
                controller: alturaController,
                textInput: "Altura en cm",
                text: "Altura"),
            const SizedBox(
              height: 15,
            ),
            // Peso
            MyTextoform(
                controller: pesoController, textInput: "Peso", text: "Peso"),
            const SizedBox(
              height: 15,
            ),
            // Alergias (multiselect)
            MyTextTitle(text: "Alergias"),
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: _selectAlergias,
                      child: const Text("Seleccionar alergias"),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: selectedAlergias
                          .map((e) => Chip(label: Text(e)))
                          .toList(),
                    ),
                  ],
                ),
              ]),
            ),

            const SizedBox(height: 15),

            // Intolerancias
            MyTextTitle(text: "Intolerancias"),
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: _selectIntolerancias,
                      child: const Text("Seleccionar intolerancias"),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: selectedIntolerancias
                          .map((e) => Chip(label: Text(e)))
                          .toList(),
                    ),
                  ],
                ),
              ]),
            ),
            const SizedBox(
              height: 15,
            ),
            // Preferencias (gustos y disgustos)
            MyTextTitle(text: "Preferencias"),
            MyTextfield(
                controller: gustosController,
                hintText: "¿Que quieres que aparezca en la dieta?",
                keyboardType: TextInputType.multiline),
            const SizedBox(
              height: 5,
            ),
            MyTextfield(
                controller: disgustosController,
                hintText: "¿Que NO quieres que aparezca en la dieta?",
                keyboardType: TextInputType.multiline),
            const SizedBox(
              height: 15,
            ),
            // Tipo de dieta
            MyTextTitle(text: "Tipo de dieta"),
            Padding(
              padding: EdgeInsets.only(left: 25, top: 10),
              child: Row(children: [
                MyDropdownMenu(
                  items: ['Omnivora', 'Vegetariana', 'Vegana', 'Keto'],
                  initialValue: selectedDieta,
                  onChanged: (newValue) {
                    setState(() {
                      selectedDieta = newValue;
                    });
                  },
                ),
              ]),
            ),
            const SizedBox(
              height: 15,
            ),
            // Restricciones culturales
            MyTextTitle(text: "Restricciones culturales"),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Row(children: [
                MyDropdownMenu(
                  items: [
                    'Ninguna',
                    'Judaismo',
                    'Islam',
                    'Hinduismo',
                    'Budismo'
                  ],
                  initialValue: selectedReligion,
                  onChanged: (newValue) {
                    setState(() {
                      selectedReligion = newValue;
                    });
                  },
                ),
              ]),
            ),
            const SizedBox(
              height: 15,
            ),
            // Precio
            MyTextoform(
                controller: precioController,
                textInput: "Cuanto te quieres gastar a la semana",
                text: "Rango de precio"),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              text: "Finalizar",
              onTap: configMenu,
              color: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      )),
    );
  }

  configMenu() async {
    try {
      await FirebaseFirestore.instance
          .collection('configuraciones')
          .doc(usuario)
          .set({
        'edad': edadController.text,
        'sexo': selectedGenero,
        'altura': alturaController.text,
        'peso': pesoController.text,
        'alergias': selectedAlergias,
        'intolerancias': selectedIntolerancias,
        'gustos': gustosController.text,
        'disgustos': disgustosController.text,
        'dieta': selectedDieta,
        'religion': selectedReligion,
        'precio': precioController.text
        // Agrega más campos según tus controladores y multiselects
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Formulario guardado correctamente",
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error al guardar: $e",
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _selectAlergias() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: ['Frutos secos', 'Marisco', 'Huevos']);
      },
    );

    if (results != null) {
      setState(() {
        selectedAlergias = results;
      });
    }
  }

  void _selectIntolerancias() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: ['Gluten', 'Lactosa', 'Fructosa']);
      },
    );

    if (results != null) {
      setState(() {
        selectedIntolerancias = results;
      });
    }
  }
}
