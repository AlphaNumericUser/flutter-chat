import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final _textController =TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;
  final List<ChatMessage> _messages = [
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [

            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue.shade100, 
              child: const Text('Ma', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 3),
            const Text('María', style: TextStyle(fontSize: 12),)
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [

            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: ( _ , index) => _messages[index],
                reverse: true,
              )
            ),

            // const Divider(height: 1),

            //todo: caja de texto
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20)
              ),
              child: _inputChat(),
            ),

          ],
        ),
      )
    );
  }

    Widget _inputChat(){

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                autocorrect: true,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: Colors.blue.shade500,
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: ( String texto) {
                  setState(() {
                    if( texto.trim().isNotEmpty ){
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              )
            ),

            // * Botón de enviar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS

                ? CupertinoButton(
                    // ignore: sort_child_properties_last
                    child: const Text('Enviar'), 
                    onPressed: _estaEscribiendo
                        ? () => _handleSubmit( _textController.text.trim() )
                        : null 
                  )

                : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1), 
                  child: IconTheme(
                    data: IconThemeData(color: Colors.blue.shade400),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: const Icon(Icons.send),
                      onPressed: _estaEscribiendo
                        ? () => _handleSubmit( _textController.text.trim() )
                        : null 
                      ),
                  )
                  )
            ),


          ],
        ),
      )
    );

  }

  // * Esta función se activa con el Submit
  _handleSubmit( String texto ){

    if ( texto.isEmpty ) return;

    // * El textController.clear limpia el texto cuando oprimimos el enter
    _textController.clear();
    // * El focusNode.requestFocus hace que se mantenga el teclado para poder seguir escribiendo
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: texto, 
      uuid: '123',
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    // * Cambiamos el estado del signo de enviar mensaje una vez enviado
    setState(() {
      _estaEscribiendo = false;
    });

  }

  @override
  void dispose() {
    // todo: off the socket

    for ( ChatMessage message in _messages ){
      message.animationController.dispose();
    }

    super.dispose();
  }

}
