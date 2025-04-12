import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_practica_ia/components/my_button.dart';
import 'package:proyecto_practica_ia/components/my_textfield.dart';
import 'package:proyecto_practica_ia/components/square_tile.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final usuarioController = TextEditingController();
  final contrasenaController = TextEditingController();

  // Método para inciar sesión
  void iniciarSesion() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usuarioController.text, password: contrasenaController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.person,
                size: 100,
              ),
              const SizedBox(height: 50),
              Text("¡Bienvenido de vuelta!",
                  style: TextStyle(color: Colors.grey[700], fontSize: 18)),
              const SizedBox(height: 25),
              MyTextfield(
                controller: usuarioController,
                hintText: 'Nombre de usuario',
                obscureText: false,
              ),
              const SizedBox(height: 25),
              MyTextfield(
                controller: contrasenaController,
                hintText: 'Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(
                    '¿Has olvidado la contraseña?',
                    style: TextStyle(color: Colors.grey[500]),
                  )
                ]),
              ),
              const SizedBox(height: 25),
              MyButton(
                text: 'Inicia Sesión',
                onTap: iniciarSesion,
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    )),
                    Text(
                      'O continua con',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ))
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(imagePath: 'lib/images/google.png'),
                  SizedBox(width: 15),
                  SquareTile(imagePath: 'lib/images/apple.png'),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿No tienes cuenta?'),
                  SizedBox(width: 5),
                  Text(
                    '¡Crea una!',
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          )),
        ));
  }
}
