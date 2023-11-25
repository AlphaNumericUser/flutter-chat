import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/mostrar_alerta.dart';

import '../services/services.dart';
import '../widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(titulo: 'Registro'),
                _Form(),
                Labels(ruta: 'login', titulo: '¿Ya tienes una cuenta?', subtitulo: 'Ingresa ahora'),
                Terminos(),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context );
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameController,
          ),

          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),

          CustomInput(
            icon: Icons.lock_outline_rounded,
            placeholder: 'Password',
            keyboardType: TextInputType.emailAddress,
            textController: passwordController,
            isPassword: true,
          ),

          CustomButton(
            text: 'Login',
            onPressed: authService.autenticando
              ? null
              : () async {
                FocusScope.of(context).unfocus();
                final registroOk = await authService.register(  nameController.text.trim(), emailController.text.trim(), passwordController.text.trim());
                if( registroOk == true ) {
                  socketService.connect();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, 'usuarios');
                } else {
                  // Mostrar alerta
                  // ignore: use_build_context_synchronously
                  mostrarAlerta(context, 'Registro incorrecto', registroOk);
                }
              }
          ),

        ],
      ),
    );
  }
}

