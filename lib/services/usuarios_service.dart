import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/models/usuarios_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    String? token = await AuthService.getToken();
    try {
      final url = Uri.parse('${Enviroment.apiUrl}/usuarios');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-token': token.toString()
      });

      final usuariosResponse = UsuariosResponse.fromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (error) {
      return [];
    }
  }
}
