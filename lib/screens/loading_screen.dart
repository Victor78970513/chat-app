import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_servoce.dart';

import 'package:chat_app/screens/screens.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context);
    final autenticado = await authService.isLoggedIn();
    if (autenticado) {
      socketService.connect();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => UsersScreen(),
            transitionDuration: Duration(milliseconds: 0)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginScreen(),
            transitionDuration: Duration(milliseconds: 0)),
      );
    }
  }
}
