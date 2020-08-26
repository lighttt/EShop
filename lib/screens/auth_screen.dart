import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthMode { Login, Signup }

class AuthScreen extends StatelessWidget {
  static const String routeName = "/auth_screen";

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 0.5),
                    Color.fromRGBO(255, 188, 117, 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1]),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: 20.0, left: 20.0, right: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 60.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black26,
                                offset: Offset(0, 2))
                          ]),
                      child: Text(
                        "Welcome to E-Shop",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontFamily: "Lato",
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  //vars
  AuthMode _authMode = AuthMode.Login;
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // firebase
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //form key
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'email': "",
    'password': "",
  };

  //saving form
  Future<void> _saveForm() async {
    if (!_formKey.currentState.validate()) {
      //form invalid
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: _authData["email"], password: _authData["password"]);
      } else {
        await _firebaseAuth.createUserWithEmailAndPassword(
            email: _authData["email"], password: _authData["password"]);
      }
    } catch (error) {}
  }

  //switch login signup
  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 340 : 300,
        width: deviceSize.width * 0.75,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 340 : 300),
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains("@")) {
                    return "Invalid Email";
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return "Password is too short";
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(labelText: "Confirm Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  onPressed: _saveForm,
                  child:
                      Text(_authMode == AuthMode.Login ? "Login" : "Sign Up"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
              FlatButton(
                onPressed: _switchAuthMode,
                child: Text(_authMode == AuthMode.Login
                    ? "Signup Instead"
                    : "Login Instead"),
                textColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
              )
            ],
          ),
        ),
      ),
    );
  }
}
