import 'package:flutter/material.dart';

class Terminos extends StatelessWidget {
  const Terminos({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: const Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200)),
    );
  }
}