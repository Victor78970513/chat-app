import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  late Usuario usuarioDestino;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('${Enviroment.apiUrl}/mensajes/$usuarioID');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': token.toString()
    });

    final mensajesResponse = MensajesResponse.fromJson(resp.body);

    return mensajesResponse.mensaje;
  }
}
