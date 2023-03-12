import 'package:flutter/material.dart';

import 'package:chat_app/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(titulo: 'Registro'),
                _Form(),
                const Labels(
                  route: 'login',
                  text1: 'Ya tienes una cuenta?',
                  text2: 'Ingresa Ahora',
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
  final TextEditingController nameCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            hintText: 'Nombre',
            textController: nameCtrl,
          ),
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
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
