import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:matcher/matcher.dart';
import 'package:flutter/material.dart';

class Sizebox extends StatelessWidget {
  const Sizebox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
      width: 300,
      child: Divider(
        color: Color.fromARGB(255, 1, 1, 1),
      ),
    );
  }
}
