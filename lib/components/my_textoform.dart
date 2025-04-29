import 'package:flutter/material.dart';

class MyTextoform extends StatelessWidget {
  final String textInput;
  final String text;
  final TextEditingController? controller;
  const MyTextoform(
      {super.key,
      required this.textInput,
      required this.text,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          )
        ]),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: textInput,
              hintStyle: TextStyle(color: Colors.grey[400])),
          keyboardType:
              TextInputType.number, // Esto hace que salga el teclado numérico
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, introduce tu edad';
            }
            final edad = int.tryParse(value);
            if (edad == null || edad <= 0) {
              return 'Edad no válida';
            }
            return null;
          },
        ),
      ]),
    );
  }
}
