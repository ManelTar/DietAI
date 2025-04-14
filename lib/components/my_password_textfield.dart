import 'package:flutter/material.dart';

class MyPasswordTextfield extends StatefulWidget {
  final controller;
  final String hintText;

  const MyPasswordTextfield({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<MyPasswordTextfield> createState() => _MyPasswordTextfieldState();
}

class _MyPasswordTextfieldState extends State<MyPasswordTextfield> {
  bool mostrarContrasena = true;

  void toogleContrasena() {
    setState(() {
      mostrarContrasena = !mostrarContrasena;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: TextField(
          controller: widget.controller,
          obscureText: mostrarContrasena,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            suffixIcon: IconButton(
              icon: Icon(
                mostrarContrasena ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: toogleContrasena,
            ),
          ),
        ));
  }
}
