// ignore_for_file: use_build_context_synchronously

import 'package:chat/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';


class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: ( context, snapshot) {
          return const Center(
                child: Text('Espere...'),
          );
        },
        
      ),
   );
  }

  Future checkLoginState( BuildContext context ) async {

    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>( context, listen: false );

    final autenticado = await authService.isLoggedIn();

    if ( autenticado ) {
      socketService.connect();
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => const UsuariosScreen(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );
    } else {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );
    }
  }
}