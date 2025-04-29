import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepseek_client/deepseek_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_practica_ia/screens/lista_screen.dart';

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
          color: Colors.grey[200],
          shadowColor: Colors.grey,
          margin: const EdgeInsets.symmetric(vertical: 10),
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.dia[0].toUpperCase() + widget.dia.substring(1),
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text("🍽 Desayuno: ${widget.comidas['desayuno'] ?? 'No disponible'}"),
                Text("🥘 Comida: ${widget.comidas['comida'] ?? 'No disponible'}"),
                Text("🌙 Cena: ${widget.comidas['cena'] ?? 'No disponible'}"),
              ],
            ),
          ),
      ),
    );
  }
}
