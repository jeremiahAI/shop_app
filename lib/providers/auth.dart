import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token, _userId;
  DateTime _expiry;
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
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async =>
      _authenticate(email, password, _signupEndpointUrl);

  Future<void> signIn(String email, String password) async =>
      _authenticate(email, password, _signInEndpointUrl);
}
