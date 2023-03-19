import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_servoce.dart';
import 'package:chat_app/services/usuarios_service.dart';
import 'package:chat_app/models/user_model.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final usuarioService = UsuariosService();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> users = [];
  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          usuario.nombre,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.black,
          ),
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.online)
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : const Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: const Icon(
            Icons.check,
            color: Colors.blue,
          ),
          waterDropColor: Colors.blue[400]!,
        ),
        child: UserListView(users: users),
      ),
    );
  }

  _loadUsers() async {
    users = await usuarioService.getUsuarios();
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }
}

class UserListView extends StatelessWidget {
  const UserListView({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<Usuario> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => UserListTile(users[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: users.length,
    );
  }
}

class UserListTile extends StatelessWidget {
  final Usuario usuario;

  const UserListTile(this.usuario, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(
          usuario.nombre.substring(0, 2),
        ),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: usuario.online ? Colors.green[300] : Colors.red),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioDestino = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
