import 'dart:async';
import 'dart:convert';
import 'package:eshop/exception/auth_expection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String _authToken;
  String _userId;
  DateTime _expiryDate;
  Timer _authTimer;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isAuth {
    return _authToken != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _authToken != null) {
      return _authToken;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String type) async {
    try {
      var response;
      if (type == "signIn") {
        response = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        response = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      _userId = response.user.uid;
      final idTokenResult = await _firebaseAuth.currentUser.getIdTokenResult();
      _authToken = idTokenResult.token;
      _expiryDate = DateTime.now()
          .add(Duration(hours: idTokenResult.expirationTime.hour));
      print(idTokenResult.expirationTime.hour);

      //start auto logout
      _autoLogout();
      notifyListeners();
      //saving shared preferences
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _authToken,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String(),
        "email": email,
      });
      prefs.setString("userData", userData);
    } catch (error) {
      AuthResultStatus status = AuthResultException.handleException(error);
      String message = AuthResultException.generatedExceptionMessage(status);
      throw message;
    }
  }

  // sign in with id token
  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, "signIn");
  }

  // sign up method with new token
  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  // logout the user
  Future<void> logout() async {
    try {
      _authToken = null;
      _userId = null;
      _expiryDate = null;
      if (_authTimer != null) {
        _authTimer.cancel();
        _authTimer = null;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _firebaseAuth.signOut();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  //autologout
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  //auto login
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    //initalize auto login
    _authToken = extractedData['token'];
    _expiryDate = expiryDate;
    _userId = extractedData['userId'];
    notifyListeners();
    _autoLogout();
    return true;
  }
}
