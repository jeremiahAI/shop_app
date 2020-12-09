import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_repository_core/shop_repository_core.dart';

class AuthImpl extends Auth {
  BehaviorSubject<String> _token;
  BehaviorSubject<String> _userId;
  DateTime _expiry;
  Timer _authTimer;

  @override
  ValueStream<bool> get isAuthenticated => token.map((event) => event != null);

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;

    final extractedData = json.decode(prefs.get('userData'));
    final extractedExpiry = DateTime.parse(extractedData['expiryDate']);

    if (!extractedExpiry.isAfter(DateTime.now())) return false;

    _token.add(extractedData['token']);
    _userId.add(extractedData['userId']);
    _expiry = extractedExpiry;
    _autoLogout();
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

      _token.add(responseData['idToken']);
      _userId.add(responseData['localId']);
      _expiry = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );
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

  @override
  Future<void> logout() async {
    _token.add(null);
    _userId.add(null);
    _expiry = null;
    _authTimer?.cancel();

    await (await SharedPreferences.getInstance()).clear();
  }

  @override
  Future<void> signUp(String email, String password) async =>
      _authenticate(email, password, Constants.signupEndpointUrl);

  @override
  Future<void> signIn(String email, String password) async =>
      _authenticate(email, password, Constants.signInEndpointUrl);

  _autoLogout() {
    if (_authTimer != null) _authTimer.cancel();

    _authTimer = Timer(
        Duration(
          seconds: _expiry.difference(DateTime.now()).inSeconds,
        ),
        logout);
  }

  @override
  ValueStream<String> get token =>
      _expiry != null && _expiry.isAfter(DateTime.now()) && _token != null
          ? _token.stream
          : null;

  @override
  ValueStream<String> get userId => _userId.stream;
}
