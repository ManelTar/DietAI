import 'package:flutter/material.dart';
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
            color: Colors.blueGrey[200],
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                "Nuevo menú",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Container(
          height: 50,
          width: 250,
          color: Colors.blueGrey[100],
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "Ver historial de menús",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          height: 50,
          width: 250,
          color: Colors.blueGrey[50],
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "Configurar menús",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
