import 'package:flutter/material.dart';

class MyTextoform extends StatelessWidget {
  final String text;
  const MyTextoform({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
            decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: text,
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
          );
  }
}