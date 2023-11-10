import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String text;
  final Function() onPressed;

  const CustomButton({
    super.key, 
    required this.text, 
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        elevation: MaterialStatePropertyAll(2),
        backgroundColor: MaterialStatePropertyAll(Colors.blue)
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 17),),
        ),
      )
    );
  }
}