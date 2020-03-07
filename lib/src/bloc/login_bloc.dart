import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:crud_api_token/src/bloc/validator.dart';

class LoginBloc with Validators {
   final _usernameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  
   Stream<String> get usernameStream =>
       _usernameController.stream.transform(validarUserName);
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream =>
      //Observable.combineLatest2(emailStream, passwordStream, (e, p) => true);
       Observable.combineLatest3(usernameStream, emailStream, passwordStream, (u, e, p) => true);

  // Insertar valores al Stream
   Function(String) get changeUserName => _usernameController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Obtener el último valor ingresado a los streams
   String get username => _usernameController.value;
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
     _usernameController?.close();
    _emailController?.close();
    _passwordController?.close();
  }
}
