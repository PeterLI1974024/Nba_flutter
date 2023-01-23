import 'package:flutter/material.dart';

class NeuBox extends StatelessWidget {
  final child;
  const NeuBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: Center(child: child),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 15,
              offset: Offset(5, 5),
            ),
            BoxShadow(
              color: Color.fromARGB(255, 154, 148, 148),
              blurRadius: 15,
              offset: Offset(-5, -5),
            ),
          ]),
    );
  }
}
