import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService api;
  final SharedPreferences prefs;

  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  AuthProvider({required this.api, required this.prefs}) {
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _token = prefs.getString('token');
  }

  Future<void> login(String username, String password) async {
    final t = await api.login(username, password);
    _token = t;
    _isLoggedIn = true;
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('token', t);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _token = null;
    await prefs.remove('isLoggedIn');
    await prefs.remove('token');
    notifyListeners();
  }
}
