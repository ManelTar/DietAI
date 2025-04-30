import 'package:flutter/material.dart';

class MyPasswordTextfield extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
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
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          controller: widget.controller,
          obscureText: mostrarContrasena,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.onSurface),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            fillColor: Theme.of(context).colorScheme.surfaceDim,
            filled: true,
            hintText: widget.hintText,
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSurface),
            suffixIcon: IconButton(
              icon: Icon(
                mostrarContrasena ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: toogleContrasena,
            ),
          ),
        ));
  }
}
