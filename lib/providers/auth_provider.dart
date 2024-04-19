import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/users.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<User?> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    const url = 'https://dummyjson.com/auth/login';
    final body = json.encode({
      'username': username,
      'password': password,
      'expiresInMins': 30,
    });

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: body);

    _isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final user = User.fromJson(responseData);
      return user;
    } else {
      throw Exception('Failed to login');
    }
  }
}
