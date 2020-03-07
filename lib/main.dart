import 'package:flutter/material.dart';

import 'package:crud_api_token/src/bloc/provider.dart';

import 'package:crud_api_token/src/pages/home_page.dart';
import 'package:crud_api_token/src/pages/login_page.dart';
import 'package:crud_api_token/src/pages/persona_page.dart';
import 'package:crud_api_token/src/pages/registro_page.dart';

import 'src/preferencias_usuario/preferencias_usuario.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();
    prefs.initPrefs();
    
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login'    : ( BuildContext context ) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'home'     : ( BuildContext context ) => HomePage(),
          'persona_page': (BuildContext context) => PersonaPage()
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
      ),
    );
      
  }
}