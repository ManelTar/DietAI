import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class UserRepository extends StatelessWidget {
  const UserRepository({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  String devolverUsuario(){
    return FirebaseAuth.instance.currentUser!.displayName.toString();
  }
}