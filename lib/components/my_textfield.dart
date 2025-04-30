import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final TextInputType keyboardType;

  const MyTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.onSurface),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            fillColor: Theme.of(context).colorScheme.surfaceDim,
            filled: true,
            hintText: hintText,
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        keyboardType: keyboardType,
      ),
    );
  }
}
