import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final users = [
    User(online: true, email: 'test1@test.com', nombre: 'victor', uid: '1'),
    User(online: true, email: 'test2@test.com', nombre: 'yerson', uid: '2'),
    User(online: true, email: 'test3@test.com', nombre: 'wiscocho', uid: '3'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi nombre',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
            // child: const Icon(Icons.offline_bolt, color: Colors.red),
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
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }
}

class UserListView extends StatelessWidget {
  const UserListView({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<User> users;

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
  final User usuario;

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
    );
  }
}
