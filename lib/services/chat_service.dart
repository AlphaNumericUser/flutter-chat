import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';
import '../models/models.dart';
import 'services.dart';

class ChatService with ChangeNotifier {
  
  Usuario? usuarioPara;

  Future <List<Mensaje>> getChat( String usuarioId ) async {
    
    final uri = Uri.parse('${ Environment.apiUrl }/mensajes/$usuarioId');
    final resp = await http.get(uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() ?? ''
      }
    );

    final mensajesResp = mensajesResponseFromJson( resp.body );
    return mensajesResp.mensajes;

  }
}
