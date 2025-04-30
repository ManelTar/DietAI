import 'package:flutter/material.dart';

class MenuCard extends StatefulWidget {
  final String dia;
  final Map<String, dynamic> comidas;

  const MenuCard({super.key, required this.dia, required this.comidas});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        shadowColor: Colors.grey,
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.dia[0].toUpperCase() + widget.dia.substring(1),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimary)),
              const SizedBox(height: 4),
              Text(
                "🍽 Desayuno: ${widget.comidas['desayuno'] ?? 'No disponible'}",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              Text("🥘 Comida: ${widget.comidas['comida'] ?? 'No disponible'}",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
              Text("🌙 Cena: ${widget.comidas['cena'] ?? 'No disponible'}",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}
