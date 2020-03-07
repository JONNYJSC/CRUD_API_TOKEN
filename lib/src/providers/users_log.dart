import 'dart:convert';

import 'package:crud_api_token/src/api/webapi.dart';
import 'package:crud_api_token/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:crud_api_token/src/utils/dialogs.dart';
import 'package:crud_api_token/src/utils/session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart' show required;
import 'package:flutter/services.dart';

class AuthAPI {
  final _session = Session();
  final _prefs = new PreferenciasUsuario();

  Future<bool> register(BuildContext context,
      {@required String username,
      @required String email,
      @required String password}) async {
    try {
      final url = '${WebApi.urlApi}/api/users/signup';

      final resp = await http.post(url,
          headers: {"content-Type": "application/json"},
          body: jsonEncode(
              {'username': username, 'email': email, 'password': password}));
      // final respString = resp.body;
      final parsed = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        final token = parsed['token'] as String;
        //Save token
        // await _session.set(token);

        _prefs.token = token;
        return true;
      } else if (resp.statusCode == 500) {
        throw PlatformException(code: '500', message: parsed['message']);
      }
      throw PlatformException(code: '201', message: parsed['Error /register']);
    } on PlatformException catch (e) {
      print('Error ${e.code}: ${e.message}');
      Dialogs.alert(context, title: 'ERROR', message: e.message);
      return false;
    }
  }

  Future<bool> login(BuildContext context,
      {@required String email, @required String password}) async {
    try {
      final authData = {
        'email': email,
        'password': password,
      };

      final url = '${WebApi.urlApi}/api/users/login';

      final resp = await http.post(url,
          headers: {"content-type": "application/json"},
          body: json.encode(authData));
      // final respString = resp.body;
      final parsed = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        final token = parsed['data'] as String;
        //Save token
        // await _session.set(token);
        _prefs.token = token;
        return true;
      } else if (resp.statusCode == 500) {
        throw PlatformException(code: '500', message: parsed['message']);
      }
      throw PlatformException(code: '201', message: parsed['Error /login']);
    } on PlatformException catch (e) {
      print('Error ${e.code}: ${e.message}');
      Dialogs.alert(context, title: 'ERROR', message: e.message);
      return false;
    }
  }

  /*Future<String> getAccessToken() async {
    try {
      final result = await _session.get();
      if (result != null) {
        final token = result as String;

        if (result != null) {
          print("token is alive");
          return token;
        }
        return null;
      }
      return null;
    } on PlatformException catch (e) {
      print("Error ${e.code}:${e.message}");
    }
  }*/
}
