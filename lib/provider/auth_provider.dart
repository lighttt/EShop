import 'package:eshop/exception/auth_expection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String authToken;
  String userId;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      userId = response.user.uid;
      authToken = await response.user.getIdToken();
      notifyListeners();
    } catch (error) {
      AuthResultStatus status = AuthResultException.handleException(error);
      String message = AuthResultException.generatedExceptionMessage(status);
      throw message;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      final response = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      userId = response.user.uid;
      authToken = await response.user.getIdToken();
      notifyListeners();
    } catch (error) {
      AuthResultStatus status = AuthResultException.handleException(error);
      String message = AuthResultException.generatedExceptionMessage(status);
      throw message;
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      authToken = null;
      userId = null;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
