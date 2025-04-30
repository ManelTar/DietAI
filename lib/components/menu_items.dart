import 'package:flutter/material.dart';
import 'package:proyecto_practica_ia/screens/config_screen.dart';
import 'package:proyecto_practica_ia/screens/lista_screen.dart';
import 'package:proyecto_practica_ia/screens/menu_screen.dart';

class MenuItems extends StatelessWidget {
  const MenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          },
          child: Container(
            height: 50,
            width: 250,
            color: Theme.of(context).colorScheme.tertiary,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                "Nuevo menú",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onTertiary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListaScreen()),
            );
          },
          child: Container(
            height: 50,
            width: 250,
            color: Theme.of(context).colorScheme.tertiary,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                "Ver lista de la compra",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onTertiary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConfigScreen()),
            );
          },
          child: Container(
            height: 50,
            width: 250,
            color: Theme.of(context).colorScheme.tertiary,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                "Configurar menús",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onTertiary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
