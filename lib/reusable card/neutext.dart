import 'package:flutter/material.dart';

class NeuText extends StatelessWidget {
  final text;
  final text1;
  final text2;
  const NeuText(
      {super.key,
      required this.text,
      required this.text1,
      required this.text2});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: text,
            style: TextStyle(fontSize: 18, color: Colors.black),
            children: [
          TextSpan(text: text1, style: TextStyle(color: Colors.black)),
          TextSpan(text: text2, style: TextStyle(color: Colors.black))
        ]));
  }
}
