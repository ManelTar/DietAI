import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:proyecto_practica_ia/components/my_button.dart';
import 'package:proyecto_practica_ia/components/my_password_textfield.dart';
import 'package:proyecto_practica_ia/components/my_textfield.dart';
import 'package:proyecto_practica_ia/components/square_tile.dart';
import 'package:proyecto_practica_ia/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usuarioController = TextEditingController();

  final contrasenaController = TextEditingController();

  // Método para inciar sesión
  void iniciarSesion() async {
    // Mostrar circulo de carga
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: LoadingAnimationWidget.stretchedDots(
              color: Theme.of(context).colorScheme.primary,
              size: 75,
            ),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usuarioController.text,
        password: contrasenaController.text,
      );
      Navigator.pop(context); // Solo si el login es exitoso
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'invalid-credential') {
        mostrarMensajeError("Email o contraseña incorrectos");
      }
    }
  }

  void mostrarMensajeError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Contraseña no es correcta"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
            child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.person,
                  size: 100,
                ),
                const SizedBox(height: 25),
                Text("¡Bienvenido de vuelta!",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18)),
                const SizedBox(height: 75),
                MyTextfield(
                  controller: usuarioController,
                  hintText: 'Nombre de usuario',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 25),
                MyPasswordTextfield(
                  controller: contrasenaController,
                  hintText: 'Contraseña',
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      '¿Has olvidado la contraseña?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    )
                  ]),
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: 'Inicia Sesión',
                  onTap: iniciarSesion,
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      )),
                      Text(
                        'O continua con',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ))
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                        onTap: () => AuthServices().signInWithGoogle(),
                        imagePath: 'lib/images/google.png'),
                    SizedBox(width: 15),
                    SquareTile(onTap: () {}, imagePath: 'lib/images/apple.png'),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿No tienes cuenta?'),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        '¡Crea una!',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
        )));
  }
}
