import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListaCard extends StatefulWidget {
  final String titulo;
  final List<Map<String, dynamic>> productos;

  const ListaCard({super.key, required this.titulo, required this.productos});

  @override
  State<ListaCard> createState() => _ListaCardState();
}

class _ListaCardState extends State<ListaCard> {
  late List<Map<String, dynamic>> productos;

  final usuario = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    productos = List.from(widget.productos);
  }

  void actualizarLista(
      String titulo, List<Map<String, dynamic>> productos) async {
    try {
      await FirebaseFirestore.instance.collection('listas').doc(usuario).set({
        'lista_compra': {
          titulo.toLowerCase().replaceAll(' ', '_'): productos,
        }
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Lista de la compra actualizada correctamente",
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Ha habido un error al actualizar la lista de la compra",
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _editarProducto(int index) async {
    final producto = productos[index];
    final TextEditingController nombreController =
        TextEditingController(text: producto['nombre']);
    final TextEditingController cantidadController =
        TextEditingController(text: producto['cantidad'].toString());

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar producto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: cantidadController,
              decoration: const InputDecoration(labelText: "Cantidad"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          ElevatedButton(
              onPressed: () {
                final nuevoProducto = {
                  "nombre": nombreController.text,
                  "cantidad": cantidadController.text,
                };

                setState(() {
                  productos[index] = nuevoProducto;
                });

                actualizarLista(widget.titulo, productos);
                Navigator.pop(context, {
                  "nombre": nombreController.text,
                  "cantidad": cantidadController.text,
                });
              },
              child: const Text("Guardar")),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        productos[index] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).colorScheme.primary,
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.titulo.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...List.generate(productos.length, (index) {
              final item = productos[index];
              return GestureDetector(
                onTap: () => _editarProducto(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "• ${item["nombre"]}: ${item["cantidad"]}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
