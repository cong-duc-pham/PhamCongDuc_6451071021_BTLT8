import 'package:flutter/material.dart';
import '../data/models/user.dart';
import '../data/services/auth_service.dart';

enum AuthState { idle, loading, success, error }

class AuthController extends ChangeNotifier {
  final AuthService _service;
  AuthController(this._service);

  AuthState state = AuthState.idle;
  String errorMessage = '';
  User? currentUser;

  Future<bool> login(String email, String password) async {
    state = AuthState.loading;
    errorMessage = '';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400)); // giả lập delay

    final user = await _service.login(email, password);
    if (user != null) {
      currentUser = user;
      state = AuthState.success;
      notifyListeners();
      return true;
    } else {
      errorMessage = 'Email hoặc mật khẩu không đúng.';
      state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    currentUser = null;
    state = AuthState.idle;
    errorMessage = '';
    notifyListeners();
  }

  void resetState() {
    state = AuthState.idle;
    errorMessage = '';
    notifyListeners();
  }
}