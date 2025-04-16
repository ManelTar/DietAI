import 'package:flutter/material.dart';

class ListaCard extends StatelessWidget {
  final String titulo;
  final List<dynamic> productos;

  const ListaCard({super.key, required this.titulo, required this.productos});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...productos.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text("• ${item["nombre"]}: ${item["cantidad"]}"),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
