import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(titulo: 'Messenger'),
                _Form(),
                const Labels(
                  route: 'register',
                  text1: 'No tienes cuenta?',
                  text2: 'Crea una ahora',
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text('Terminos y condiciones de uso',
                      style: TextStyle(fontWeight: FontWeight.w300)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            hintText: 'Password',
            textController: passCtrl,
            isPassword: true,
          ),
          const SizedBox(height: 30),
          BlueButton(
            text: 'Ingrese',
            onPressed: authService.autenticando
                ? () => null
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());
                    if (loginOk) {
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showAlert(context, 'Login Incorrecto',
                          'Revise sus credenciales');
                    }
                  },
          )
        ],
      ),
    );
  }
}
