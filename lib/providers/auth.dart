import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token, _userId;
  DateTime _expiry;
  Timer _authTimer;

  static const String webApiKey = "AIzaSyAhDp8ZUDFqArD6USlMVT2pMXFkoT-ZGC4";
  static const _signupEndpointUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$webApiKey";
  static const _signInEndpointUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$webApiKey";

  bool get isAuthenticated => token != null;

  String get token =>
      _expiry != null && _expiry.isAfter(DateTime.now()) && _token != null
          ? _token
          : null;

  String get userId => _userId;

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;

    final extractedData = json.decode(prefs.get('userData'));
    final extractedExpiry = DateTime.parse(extractedData['expiryDate']);

    if (!extractedExpiry.isAfter(DateTime.now())) return false;

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiry = extractedExpiry;
    _autoLogout();
    notifyListeners();
    return true;
  }

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      final response = await post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null)
        throw HttpException(responseData['error']['message']);

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiry = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );
      notifyListeners();
      _autoLogout();

      final prefs = await SharedPreferences.getInstance();

      prefs.setString(
          'userData',
          json.encode({
            'token': token,
            'userId': userId,
            'expiryDate': _expiry.toIso8601String()
          }));
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _token = null;
    _expiry = null;
    _expiry = null;
    if (_authTimer != null) _authTimer.cancel();

    await (await SharedPreferences.getInstance()).clear();
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async =>
      _authenticate(email, password, _signupEndpointUrl);

  Future<void> signIn(String email, String password) async =>
      _authenticate(email, password, _signInEndpointUrl);

  _autoLogout() {
    if (_authTimer != null) _authTimer.cancel();

    _authTimer = Timer(
        Duration(
          seconds: _expiry.difference(DateTime.now()).inSeconds,
        ),
        logout);
  }
}
