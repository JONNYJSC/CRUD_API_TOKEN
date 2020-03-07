import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session {
  final key = 'SESSION';
  final storage = new FlutterSecureStorage();

  set(String token) async {
    //  final data = {
    //    'token': token
    //  };
    await storage.write(key: key, value: jsonEncode(token));
    // print(token);
  }

  get() async {
    final result = await storage.read(key: key);
    if(result != null) {
      return jsonDecode(result);
    }
    return null;
  }
  clear() async{
    await storage.deleteAll();
  }
}