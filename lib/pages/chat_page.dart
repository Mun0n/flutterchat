import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<ChatMessage> _messages = [];

  bool _isWritting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              CircleAvatar(
                child: Text(
                  'Te',
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                'Melissa Flores',
                style: TextStyle(color: Colors.black87, fontSize: 12),
              )
            ],
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                  child: ListView.builder(
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
                physics: BouncingScrollPhysics(),
                reverse: true,
              )),
              Divider(
                height: 1,
              ),
              Container(
                color: Colors.white,
                height: 100,
                child: _inputChat(),
              )
            ],
          ),
        ));
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (text) {
                setState(() {
                  if (text.trim().length > 0) {
                    _isWritting = true;
                  } else {
                    _isWritting = false;
                  }
                });
              },
              decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: _isWritting
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isWritting
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String text) {
    if (text.length == 0) return;
    print(text);
    setState(() {
      _isWritting = false;
    });
    final newMessage = ChatMessage(
      uid: '123',
      text: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    _focusNode.requestFocus();
    _textController.clear();
  }

  @override
  void dispose() {
    // TODO: Off del socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
