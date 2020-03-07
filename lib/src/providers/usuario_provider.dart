import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crud_api_token/src/api/webapi.dart';
import 'package:crud_api_token/src/preferencias_usuario/preferencias_usuario.dart';

class UsuarioProvider {
    String _url = WebApi.urlApi;
    final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> nuevoUsuario(
      String username, String email, String password) async {
    final authData = {
       'username': username,
      'email': email,
      'password': password,
    };

    final resp = await http.post(
        '$_url/api/users/signup',
        headers: {"content-type": "application/json"},
        body: json.encode(authData));
         
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('data')) {

      _prefs.token = decodedResp['data'];     

      return {'ok': true, 'token': decodedResp['data']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }
  
  Future<Map<String, dynamic>> login(String email, String password) async {

    final authData = {
      'email': email,
      'password': password,
    };

    final url = '$_url/api/users/login';
    final resp = await http.post(url,
    headers: {"content-type": "application/json"},
    body: json.encode(authData));

    final decodedData = json.decode(resp.body);
    print(decodedData);
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('data')) {

      _prefs.token = decodedResp['data'];
      
      return {'ok': true, 'token': decodedResp['data']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }
  
}