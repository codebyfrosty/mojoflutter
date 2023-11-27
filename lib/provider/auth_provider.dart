import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// email: hilmiahmad@gmail.com
// pass: Abcd1234
class AuthProvider extends ChangeNotifier {
  LoginData? _user;

  LoginData? get user => _user;

  bool get isLoggedIn => _user != null;
  bool _isLoggedIn = false; // Initialize with false

  String _error = '';
  String get error => _error;
  bool get loggedIn => _isLoggedIn;

  Future<void> login({String? email, String? password}) async {
    final response = await http.post(Uri.parse('$baseUrl/auth/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['data'];
      LoginData loginData = LoginData.fromJson(responseData);

      // debugPrint('[login success] $loginData

      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('name', loginData.user.name); // Save name as string
      prefs.setString('email', loginData.user.email);
      prefs.setString('refresh_token',
          loginData.refreshToken); // Save refresh token as string
      prefs.setString(
          'access_token', loginData.accessToken); // Save access token as string
      debugPrint('refresh token : ${loginData.refreshToken}');
      debugPrint('access token : ${loginData.accessToken}');

      _isLoggedIn = true;
      _user = loginData;
      notifyListeners();
    } else if (response.statusCode == 401) {
      final responseBody = jsonDecode(response.body)['errors'];
      final errorMessage = responseBody['message'];
      debugPrint('[login 401 error] $errorMessage');
      _error = errorMessage; // Set the error message
      _isLoggedIn = false;
    } else {
      debugPrint('[login error] ${response.body}');

      throw Exception(jsonDecode(response.body));
    }
  }

  Future<void> register(
      {String? name,
      String? password,
      String? email,
      String? phone,
      String? confirm_password}) async {
    final response = await http.post(
        Uri.parse(
          '$baseUrl/auth/register',
        ),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'confirm_password': confirm_password,
        }));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['data'];
      final message = jsonDecode(response.body)['message'];

      debugPrint('[register sukses] $responseData');
      debugPrint('[register sukses] $message');

      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      _isLoggedIn = true;

      _user = user;
      notifyListeners();
    } else if (response.statusCode == 401) {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['errors']['message'];
      debugPrint('[register 401 error] $errorMessage');
      _isLoggedIn = false;
      _error = errorMessage; // Set the error message

      return errorMessage;
    } else {
      final responseBody = jsonDecode(response.body)['errors'];
      final errorMessage = responseBody['message'];
      _error = errorMessage; // Set the error message

      debugPrint('[register error] $errorMessage');
      throw Exception(errorMessage);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    final accesstoken = prefs.getString('access_token');

    final response = await http.post(Uri.parse('$baseUrl/auth/revoke-token'),
        headers: {'Authorization': 'Bearer $accesstoken'},
        body: jsonEncode(
          {'refresh_token': refreshToken},
        ));

    if (response.statusCode == 200) {
      // Clear user data from SharedPreferences
      prefs.setBool('isLoggedIn', false);

      prefs.clear();

      // Update the logged-in status and user data in the provider
      _isLoggedIn = false;
      _user = null;
      notifyListeners();
    } else {
      return jsonDecode(response.body)['message'];
    }
  }
}

class ChangePassProvider with ChangeNotifier {
  String _error = '';
  String get error => _error;

  Future<String> changePassword(String oldPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final url = Uri.parse(
        '$baseUrl/auth/change-password'); // Replace with your API endpoint

    final requestData = {
      "old_password": oldPassword,
      "new_password": newPassword,
      "confirm_password": newPassword,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        // Password changed successfully
        debugPrint('[change password success] ${response.body}');
        _error = '';
        notifyListeners();
        return 'success';
      } else if (response.statusCode == 400) {
        final responseData = json.decode(response.body);
        final errors = responseData['errors'];
        debugPrint('[change password error] $errors');
        _error = 'An error occurred: $errors';
        notifyListeners();
        return _error;
      } else {
        _error = 'Terjadi kesalahan';
        notifyListeners();
        return _error;
      }
    } catch (error) {
      _error = 'Terjadi kesalahan';
      notifyListeners();
      return _error;
    }
  }
}
