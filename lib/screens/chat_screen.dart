import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../services/services.dart';
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

  late ChatService chatService;
  SocketService? socketService;
  AuthService? authService;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    socketService?.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial( chatService.usuarioPara!.uid );
  }

  void _cargarHistorial( String usuarioId ) async {

    List<Mensaje> chat = await chatService.getChat(usuarioId);
    final history = chat.map((m) => ChatMessage(
      texto: m.mensaje, 
      uuid: m.de, 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 0))..forward(),
    ));

    setState(() {
      _messages.insertAll(0, history);
    });

  }

  void _escucharMensaje( dynamic payload ) {

    ChatMessage message = ChatMessage(
      texto: payload['mensaje'], 
      uuid: payload['de'],
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300)),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();

  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [

            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue.shade100, 
              child: Text(usuarioPara!.nombre.substring(0,2), style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 3),
            Text(usuarioPara.nombre, style: const TextStyle(fontSize: 12),)
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
      uuid: authService!.usuario!.uid,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    // * Cambiamos el estado del signo de enviar mensaje una vez enviado
    setState(() {
      _estaEscribiendo = false;
    });

    socketService?.emit('mensaje-personal', {
      'de': authService!.usuario?.uid,
      'para': chatService.usuarioPara!.uid,
      'mensaje': texto
    });

  }

  @override
  void dispose() {
    // todo: off the socket

    for ( ChatMessage message in _messages ){
      message.animationController.dispose();
    }

    socketService?.socket.off('mensaje-personal');
    super.dispose();
  }

}
