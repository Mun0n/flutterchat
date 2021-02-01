import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  User user;
  bool _authInProgress = false;

  final _storage = new FlutterSecureStorage();

  bool get authInProgress => this._authInProgress;
  set authInProgress(bool value) {
    this._authInProgress = value;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<String> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.authInProgress = true;
    final data = {'email': email, 'password': password};
    print(data);
    final resp = await http.post('${Environment.apiUrl}/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    this.authInProgress = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    this.authInProgress = true;
    final data = {'nombre': name, 'email': email, 'password': password};
    print(data);
    final resp = await http.post('${Environment.apiUrl}/login/new',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    this.authInProgress = false;
    if (resp.statusCode == 200) {
      final registerResponse = loginResponseFromJson(resp.body);
      this.user = registerResponse.user;
      await this._saveToken(registerResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    if (token != null) {
      final resp = await http.get('${Environment.apiUrl}/login/renew',
          headers: {'Content-Type': 'application/json', 'x-token': token});
      print('Respuesta loggedin ${resp.body}');
      if (resp.statusCode == 200) {
        final registerResponse = loginResponseFromJson(resp.body);
        this.user = registerResponse.user;
        await this._saveToken(registerResponse.token);
        return true;
      } else {
        this._logout();
        return false;
      }
    } else {
      this._logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    await _storage.delete(key: 'token');
  }
}
