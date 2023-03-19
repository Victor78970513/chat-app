import 'dart:io';

import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_servoce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  bool _isWriting = false;

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatService.usuarioDestino.uid);
    super.initState();
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await chatService.getChat(usuarioID);

    final history = chat.map((mensaje) => ChatMessage(
        text: mensaje.mensaje,
        uid: mensaje.de,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 0),
        )..forward()));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
      text: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300)),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioDestino = chatService.usuarioDestino;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              maxRadius: 23,
              backgroundColor: Colors.blue[100],
              child: Text(usuarioDestino.nombre.substring(0, 2),
                  style: const TextStyle(fontSize: 22)),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            Text(usuarioDestino.nombre,
                style: const TextStyle(color: Colors.black, fontSize: 20)),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
              ),
            ),
            const Divider(height: 1),
            //TODO CAJA DE TEXTO
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xffFFE4C4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (String texto) {
                setState(() {
                  if (texto.trim().isNotEmpty) {
                    _isWriting = true;
                  } else {
                    _isWriting = false;
                  }
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Enviar mensaje',
              ),
              focusNode: _focusNode,
            ),
          ),

          // Boton para enviar mensaje
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: _isWriting
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                    child: const Text('Enviar'),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[200]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(Icons.send),
                        onPressed: _isWriting
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String texto) {
    if (texto.isEmpty) return;

    final newMessage = ChatMessage(
      text: texto,
      uid: authService.usuario.uid,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    _textController.clear();
    _focusNode.requestFocus();
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });
    socketService.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.usuarioDestino.uid,
      'mensaje': texto,
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
