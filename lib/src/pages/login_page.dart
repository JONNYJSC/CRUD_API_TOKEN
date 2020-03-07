import 'package:crud_api_token/src/providers/users_log.dart';
import 'package:crud_api_token/src/utils/responsive.dart';
import 'package:crud_api_token/widgets/circle.dart';
import 'package:crud_api_token/widgets/input_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final _autAPI = AuthAPI();
  var _email = '', _password = '';
  var _isFetching = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  _submit() async {
    if (_isFetching) return;
    final isValued = _formkey.currentState.validate();
    if (isValued) {
      setState(() {
        _isFetching = true;
      });
    }
    if (isValued) {
      final isOk =
          await _autAPI.login(context, email: _email, password: _password);
      setState(() {
        _isFetching = false;
      });
      if (isOk) {
        print('LOGIN OK');
        Navigator.pushNamedAndRemoveUntil(context, 'home', (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                right: -size.width * 0.22,
                top: -size.width * 0.36,
                child: Circle(
                  radius: size.width * 0.45,
                  colors: [
                    Colors.pink,
                    Colors.pinkAccent,
                  ],
                ),
              ),
              Positioned(
                left: -size.width * 0.15,
                top: -size.width * 0.34,
                child: Circle(
                  radius: size.width * 0.35,
                  colors: [
                    Colors.orange,
                    Colors.deepOrange,
                  ],
                ),
              ),
              SingleChildScrollView(
                  child: Container(
                width: size.width,
                height: size.height,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(children: <Widget>[
                        Container(
                          width: responsive.wp(20),
                          height: responsive.wp(20),
                          margin: EdgeInsets.only(top: size.width * 0.3),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 25)
                              ]),
                        ),
                        SizedBox(height: responsive.hp(4)),
                        Text(
                          'Welcome',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.w300),
                        )
                      ]),
                      Column(
                        children: <Widget>[
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 310,
                                minWidth: 310,
                              ),
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  children: <Widget>[
                                    InputText(
                                      label: 'Email Addres',
                                      inputType: TextInputType.emailAddress,
                                      fontSize: responsive.ip(1.8),
                                      validator: (String text) {
                                        if (text.contains('@')) {
                                          _email = text;
                                          return null;
                                        } else
                                          return 'Invalid Email';
                                      },
                                    ),
                                    SizedBox(height: responsive.hp(3)),
                                    InputText(
                                      label: 'Password',
                                      isSecure: true,
                                      fontSize: responsive.ip(1.8),
                                      validator: (String text) {
                                        if (text.isNotEmpty &&
                                            text.length > 3) {
                                          _password = text;
                                          return null;
                                        } else
                                          return 'Invalid Password';
                                      },
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(height: responsive.hp(4)),
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 350,
                                minWidth: 350,
                              ),
                              child: CupertinoButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: responsive.ip(2)),
                                color: Colors.pinkAccent,
                                borderRadius: BorderRadius.circular(4),
                                onPressed: () => _submit(),
                                child: Text(
                                  'Sign In',
                                  style:
                                      TextStyle(fontSize: responsive.ip(2.5)),
                                ),
                              )),
                          SizedBox(height: responsive.hp(2)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('New to friendly Desi?',
                                  style: TextStyle(
                                      fontSize: responsive.ip(1.8),
                                      color: Colors.black54)),
                              CupertinoButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, 'signup'),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: responsive.ip(1.8),
                                      color: Colors.pinkAccent),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: responsive.hp(5))
                        ],
                      )
                    ],
                  ),
                ),
              )),
              _isFetching
                  ? Positioned.fill(
                      child: Container(
                      color: Colors.black45,
                      child: Center(
                        child: CupertinoActivityIndicator(radius: 15),
                      ),
                    ))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}