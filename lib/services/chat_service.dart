import 'package:chat/global/environment.dart';
import 'package:chat/models/messages_response.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  User userDestination;

  Future getChat(String userId) async {
    final resp = await http.get('${Environment.apiUrl}/messages/$userId',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });

    final messagesResp = messagesResponseFromJson(resp.body);
    return messagesResp.messages;
  }
}
