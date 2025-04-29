import 'package:flutter/material.dart';

class MyTextTitle extends StatelessWidget {
  final String text;
  const MyTextTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      ),
    );
  }
}
