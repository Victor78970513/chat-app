import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isWriting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            const SizedBox(width: 30),
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: const Text('Te', style: TextStyle(fontSize: 12)),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.15),
            const Text('Victor Choque',
                style: TextStyle(color: Colors.black, fontSize: 12)),
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
    print(texto);
    _isWriting = false;
    final newMessage = ChatMessage(
      text: texto,
      uid: '123',
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    _textController.clear();
    _focusNode.requestFocus();
    newMessage.animationController.forward();
    setState(() {});
  }

  @override
  void dispose() {
    //TODO off del socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
