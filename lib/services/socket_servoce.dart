import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  Socket get socket => _socket;
  get emit => _socket.emit;

  void connect() async {
    final token = await AuthService.getToken();

    _socket = io(
        Enviroment.socektUrl,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({'x-token': token})
            .build());

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
