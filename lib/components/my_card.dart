import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String dia;
  final Map<String, dynamic> comidas;

  const MenuCard({super.key, required this.dia, required this.comidas});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dia[0].toUpperCase() + dia.substring(1),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text("🍽 Desayuno: ${comidas['desayuno'] ?? 'No disponible'}"),
            Text("🥘 Comida: ${comidas['comida'] ?? 'No disponible'}"),
            Text("🌙 Cena: ${comidas['cena'] ?? 'No disponible'}"),
          ],
        ),
      ),
    );
  }
}
