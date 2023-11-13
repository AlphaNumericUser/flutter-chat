import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String texto;
  final String uuid;
  final AnimationController animationController;

  const ChatMessage({
    super.key, 
    required this.texto, 
    required this.uuid, 
    required this.animationController
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeInBack),
        child: Container(
          child: uuid == '123'
            ? _myMessage()
            : _notMyMessage()
        ),
      ),
    );
  }
  
  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 6,
          left: 50,
          right: 6
        ),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(16)
        ),
        child: Text(texto, style: const TextStyle(color: Colors.white),),
      ),
    );
  }
  
  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 6,
          left: 6,
          right: 50
        ),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(16)
        ),
        child: Text(texto, style: const TextStyle(color: Colors.black),),
      ),
    );
  }
}