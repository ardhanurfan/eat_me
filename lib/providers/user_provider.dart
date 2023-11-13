import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  String _errorMessage = '';
  late UserModel _user;

  String get errorMessage => _errorMessage;
  UserModel get user => _user;

  Future<bool> signUp(
      {required String email,
      required String password,
      required String name,
      required String username}) async {
    try {
      bool isUsernameUsed = !(await UserService()
          .usernameCheck(username: username, isEdit: false));
      if (isUsernameUsed) {
        _errorMessage = "Username not available";
        return false;
      } else {
        _user = await AuthService().signup(
            email: email, name: name, password: password, username: username);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message.toString();
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      _user = await AuthService().signIn(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message.toString();
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await AuthService().signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message.toString();
      return false;
    }
  }

  Future<bool> getUserById({required String id}) async {
    try {
      _user = await UserService().getUserbyId(id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
