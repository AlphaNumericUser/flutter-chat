import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/models.dart';
import '../services/services.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {

  final usuarioService = UsuariosService();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text( usuario!.nombre, style: const TextStyle(color: Colors.black87) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          }, 
          icon: const Icon(Icons.exit_to_app_rounded)
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: (socketService.serverStatus == ServerStatus.online)
              ? Icon(Icons.check_circle, color: Colors.blue[400],)
              : const Icon(Icons.offline_bolt_rounded, color: Colors.red,),
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
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = usuario;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }

  _cargarUsuarios() async {
    usuarios = await usuarioService.getUsuarios();
    setState(() {});
    // await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

}