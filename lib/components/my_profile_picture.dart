import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePicture extends StatefulWidget {
  const MyProfilePicture({super.key});

  @override
  State<MyProfilePicture> createState() => _MyProfilePictureState();
}

class _MyProfilePictureState extends State<MyProfilePicture> {
  Uint8List? imagenElegida;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cambiarFoto,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
            image: imagenElegida != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.memory(imagenElegida!, fit: BoxFit.cover).image)
                : null),
        child: const Center(
          child: Icon(
            Icons.person_rounded,
            color: Colors.black38,
            size: 35,
          ),
        ),
      ),
    );
  }

  void cambiarFoto() async {
    final usuario = FirebaseAuth.instance.currentUser?.uid;

    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child("${usuario} + .jpg");
    final imageBytes = await imagen.readAsBytes();
    await imageRef.putData(imageBytes);
    
    setState(() => imagenElegida = imageBytes);
  }
}
