import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/models.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: '1', nombre: 'María', email: 'test1@test.com', online: true),
    Usuario(uid: '2', nombre: 'Melissa', email: 'test2@test.com', online: false),
    Usuario(uid: '3', nombre: 'Fernando', email: 'test3@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text( usuario!.nombre, style: const TextStyle(color: Colors.black87) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            // TODO: Desconectar del socket server
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          }, 
          icon: const Icon(Icons.exit_to_app_rounded)
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            // child: Icon(Icons.check_circle, color: Colors.blue[400],),
            child: const Icon(Icons.offline_bolt_rounded, color: Colors.red,),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color:  Colors.green[400],),
          waterDropColor: Colors.purple.shade100,
        ),
        child: _listViewUsuarios(),
      )
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(

      physics: const BouncingScrollPhysics(),
      itemBuilder: ( _ , index) =>  _usuarioListTile( usuarios[index] ), 
      separatorBuilder: ( _ , index) => const Divider(thickness: 0), 
      itemCount: usuarios.length,

    );
  }

  ListTile _usuarioListTile( Usuario usuario ) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0,2)),
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red[400],
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }

  _cargarUsuarios() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

}