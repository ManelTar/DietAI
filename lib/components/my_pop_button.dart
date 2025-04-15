import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:proyecto_practica_ia/components/menu_items.dart';

class MyPopButton extends StatelessWidget {
  const MyPopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(
          context: context,
          bodyBuilder: (context) => MenuItems(),
          width: 250,
          height: 150,
          backgroundColor: Colors.blueGrey.shade100),
      child: const Icon(Icons.add),
    );
  }
}
